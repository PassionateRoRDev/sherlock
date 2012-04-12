require 'digest/md5'
require 'zip/zip'

class Video < ActiveRecord::Base
  
  include FileAssetUtils
  include BlockDetail
  
  belongs_to :block
  
  attr_accessor :uploaded_file
  attr_accessor :uploaded_thumbnail
  
  attr_accessor :capture_start, :capture_end
    
  validate :require_upload_for_a_new_video, :unless => :persisted?  
  
  before_save :process_upload, :if => :has_uploaded_file?
  before_save :process_thumbnail_upload, :if => :has_uploaded_thumbnail?
      
  after_save :invalidate_report
  
  # important: after_update not after_save
  after_update :check_for_thumbnail_pos_change
  
  before_destroy :delete_files
  before_destroy :delete_thumbnail
  
  def self.generate(block)
    Video.new(
      :block          => block,
      :unique_code    => generate_unique_code,
      :thumbnail_pos  => '00:00:01'
    )
  end

  def ffmpeg_path
    '/usr/local/bin/ffmpeg'
  end
  
  def file_type
    'videos'
  end
  
  def check_if_3gpp
    self.path.to_s.downcase.end_with? '.3gp'
  end
    
  def thumbnail_method
    self.thumbnail_pos.blank? ? :manual : :auto
  end
  
  def width_for_display(max_width)    
    width > max_width ? max_width : width
  end  
  
  def online_dims
    max_width = Report::MAX_PAGE_WIDTH
    min_width = 450
    result = Picture.scale_to_bounds([width, height], [max_width, 0])
    ratio = (0.0 + result[1]) / result[0]
    if result[0] < min_width
      result[0] = min_width
      result[1] = (ratio * result[0]).round
    end
    result
  end
  
  def extract_thumbnail_from_zip    
    self.thumbnail = path.sub(/([^.]+)$/, 'jpg')
    Zip::ZipFile.open(full_filepath) do |zip_file|      
      zip_file.each do |frame|          
        zip_file.extract(frame, full_thumbnail_path)
        break
      end                
    end    
  end
  
  def extract_thumbnail_from_movie    
        
    if thumbnail_pos.to_s.present?      
      delete_thumbnail
      
      self.thumbnail = path.sub(/([^.]+)$/, 'png')
      command = "#{ffmpeg_path} -i #{full_filepath} -vframes 1 " +
                " -ss #{thumbnail_pos} " +
                " -f image2 #{full_thumbnail_path} 2>&1"    
      
      Rails::logger.debug("Command is: " + command)
      result = `#{command}`
      Rails::logger.debug("Result of the thumbnail command: " + result)

      update_dims_from_thumbnail    
    
    end      
  end
  
  def is_zip?    
    path.end_with? '.zip'    
  end    
  
  def calculate_fps(frames_count, duration_miliseconds)
    (frames_count == 0) ? 15 : sprintf('%.04f', (frames_count * 1000.0) / duration_miliseconds)
  end
  
  def capture_duration
    capture_end.to_i - capture_start.to_i
  end
  
  def extract_frames(frames_dir)    
    ev = Event.create(
      :event_type => 'unzip', 
      :detail_i1  => File.size(full_filepath)
    )                        
    Zip::ZipFile.open(full_filepath) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(frames_dir, f.name)     
        zip_file.extract(f, f_path)        
      end
    end        
    ev.finish
    
  end
     
  #
  # ffmpeg options specific to the video format
  #
  def extra_video_options_for_format(format)
    case format.to_s
    when 'flv'
      '-ar 44100 -qmax 30'
    else
      ''      
    end
  end    
  
  def update_dims_from_thumbnail
    dims = Dimensions.dimensions full_thumbnail_path
    self.width  = dims[0]
    self.height = dims[1]
  end
  
  def save_first_frame_as_thumbnail(frames_dir)    
    
    delete_thumbnail
    self.thumbnail = self.path.sub(/([^.]+)$/, 'jpg')    
    first_frame = frame_files(frames_dir).first
    
    Rails::logger.debug "Thumbnail: #{self.thumbnail}"
    
    Rails::logger.debug "First frame is:"
    Rails::logger.debug first_frame
    
    Rails::logger.debug "Copying to #{full_thumbnail_path}"
    
    FileUtils.copy_file(first_frame, full_thumbnail_path)
    update_dims_from_thumbnail
  end
  
  def frame_files(frames_dir)
    Dir["#{frames_dir}/*.jpg"]
  end
    
  def frames_count(frames_dir)            
    frame_files(frames_dir).count
  end
  
  def encode_do(frames_dir, ext)
    
    video_filename = self.path.sub(/([^.]+)$/, ext)        
    video_full_path = File.join base_dir, video_filename
                
    sound_options = encode_mp3_sound frames_dir
    extra_video_options = extra_video_options_for_format ext            
                
    command = "#{ffmpeg_path} -r #{fps} -b 1800 " +
              " -i #{frames_dir}/%06d.jpg #{extra_video_options} " +
              " #{sound_options} -y #{video_full_path} 2>&1"
            
    Rails::logger.debug("Command: #{command}")    
    ev = Event.create(:event_type => 'video_encode_frames')
    result = `#{command}`
    ev.finish
    
    Rails::logger.debug("Result of the command: " + result)            
    video_filename
    
  end
  
  #
  # Encode the video from a .zip containing video frames (as JPEG images)
  # and optional sound file in AIFF format.
  # 
  # For some reason encoding to mov produces the best results. We recode
  # to other formats (mpg, flv) in the post-processing step. Also tests
  # shown that it's not possible to encode .mpg with frame rates smaller
  # than 19-20; but it's possible to RECODE to mpg from, say, mov where
  # frame rate is 15-16. 
  #
  # Side effects:
  # 
  # - set content_type
  # - set path
  # - set fps
  # - set (and overwrite) thumbnail
  #
  def encode_from_zip
    
    Rails::logger.debug 'Encoding from zip'
    
    full_zip_path = full_filepath    
    frames_dir = full_filepath + '_frames'    
    FileUtils.mkdir frames_dir    
    extract_frames frames_dir    
    self.fps = calculate_fps(frames_count(frames_dir), capture_duration)                    
    self.content_type = 'video/quicktime'
    ext = 'mov'    
    self.path = encode_do(frames_dir, ext)            
    save_first_frame_as_thumbnail frames_dir        
    # remove the zip & frame images (whole dir)
    File.unlink full_zip_path
    FileUtils.rm_rf frames_dir    
  end
  
  #
  # Encode the .AIFF sound file into MP3 (if it exists in the target directory)
  # 
  # Return: options for ffmpeg for embedding the result sound file
  #
  def encode_mp3_sound(frames_dir)    
    src_file = "#{frames_dir}/sound.aiff"
    if File.exists? src_file
      ev = Event.create(:event_type => 'convert_aiff')      
      command = "#{ffmpeg_path} -i #{src_file} -f mp3 -acodec libmp3lame " +
                " -ab 192000 -ar 44100 #{frames_dir}/sound.mp3 2>&1"
      result = `#{command}`
      Rails::logger.debug result
      ev.finish
      "-i #{frames_dir}/sound.mp3 -acodec copy"
    else
      ""
    end      
  end      
      
  def self.populate_missing_codes
    Video.where(:unique_code => nil).each do |video|
      video.unique_code = Video.generate_unique_code
      video.save
    end  
    Video.where(:unique_code => '').each do |video|
      video.unique_code = Video.generate_unique_code
      video.save
    end  
  end
  
  def full_thumbnail_path
    filepath_for_filename thumbnail
  end  
  
  def path_for_format(format)
    path_for_suffix format    
  end
  
  def flv_path
    path_for_format(:flv)
  end
  
  def m4v_path
    path_for_format(:m4v)
  end
  
  def avi_path
    path_for_format(:avi)
  end
  
  def mpg_path
    path_for_format(:mpg)
  end
  
  def full_path_for_format(format)
    if format == :original    
      full_filepath
    else
      full_path_for_suffix format
    end    
  end
  
  def recode_to_flv_and_then_to_mpg
    recode_to_format :flv
    recode_to_format :mpg, :flv
  end
  
  def recode_to_formats
    if check_if_3gpp
      recode_to_flv_and_then_to_mpg
    else
      recode_to [:flv, :mpg]
    end    
  end
    
  def recode_command(video_path, new_video_path, format)
    extra_flags = ''
    if format == :m4v
        extra_flags += ' -vprofile baseline'
    end
    "#{ffmpeg_path} -i #{video_path} #{extra_flags} -strict experimental " +
    " -deinterlace -ar 44100 -y -r 25 -qmin 3 -qmax 6 #{new_video_path} 2>&1"        
  end
  
  def recode_to_format(format, source_format = :original)
        
    unless self.path == path_for_format(format)      
      video_path = full_path_for_format source_format
      new_video_path = full_path_for_format(format)        
      command = recode_command video_path, new_video_path, format        
      Rails::logger.debug("Recode command: " + command)
      ev = Event.create(
                :event_type => 'video_recode', 
                :detail_s1 => format,
                :detail_s2 => source_format,
                :detail_i1 => self.id
      )
      result = `#{command}`      
      ev.finish
      Rails::logger.debug("Recode result: " + result)      
    end
  end
  
  def recode_to(formats, source_format = :original)        
    formats.each { |format| recode_to_format(format, source_format) }
  end
  
  def thumbnail_path
    File.join base_dir, self.thumbnail
  end
  
  def rename_thumbnail
    thumbnail_path =~ /([^.]+)$/
    thumbnail_ext = $1    
    new_thumbnail_filename = self.path.sub(/([^.]+)$/, thumbnail_ext)
    new_thumbnail_path = File.join base_dir, new_thumbnail_filename                         
    File.rename(thumbnail_path, new_thumbnail_path)
    self.thumbnail = new_thumbnail_filename    
  end
  
  def delete_thumbnail
    Rails::logger.debug('Delete thumbnail: ' + self.thumbnail.to_s)
    if self.thumbnail      
      File.unlink(thumbnail_path) if File.exists?(thumbnail_path)
    end
  end
    
  def delete_files
    delete_file
    [:flv, :m4v, :avi, :mpg, :swf, :mov].each do |format|        
      full_path = full_path_for_format(format)
      File.unlink(full_path) if File.exists?(full_path)
    end
  end
  
  def type_from_content_type(content_type)
    content_type ? content_type.split('/').last : ''    
  end
  
  def as_json(options = {})
    options[:except] ||= []
    options[:except] += [:original_filename]
    result = super(options)        
    result['caption'] = result['title']
    result['type']    = type_from_content_type(self.content_type)
    
    if options[:for_pdf]      
      # apply MPG for the PDF format:      
      result['path'] = self.mpg_path 
      result['type'] = 'mpeg'      
    end
    
    result
  end 
  
  def self.generate_unique_code
    len = 10
    code = ''
    until code.present? && (!Picture.find_by_unique_code(code))
      code = generate_random_code(len)
    end
    code    
  end
  
  private
  
  def process_thumbnail_upload
    
    Rails::logger.debug 'Processing the uploaded thumbnail'
    
    delete_thumbnail
    self.thumbnail = self.path.sub(/([^.]+)$/, 'jpg')                 
    File.open(thumbnail_path, 'wb') { |f| f.write uploaded_thumbnail.read }
    self.thumbnail_pos = nil
    update_dims_from_thumbnail
  end
  
  def process_upload    
    
    save_uploaded_file
    
    is_zip = is_zip?    
    encode_from_zip if is_zip
    
    recode_to_formats        

    # if no thumbnail was passed AND it was not a .zip file, extract thumbnail
    # from the movie
    
    Rails::logger.debug("Is zip: #{is_zip}")
    
    extract_thumbnail_from_movie unless (is_zip || has_uploaded_thumbnail?)    
    
  end
    
  def check_for_thumbnail_pos_change
    extract_thumbnail_from_movie if self.thumbnail_pos_changed?          
  end
  
  def save_uploaded_file
              
    delete_files if persisted?        
    
    self.content_type       = uploaded_file.content_type
    self.original_filename  = uploaded_file.original_filename            
    
    self.path = store_from_source self.original_filename, uploaded_file
    
  end
  
  def has_uploaded_file?
    !uploaded_file.nil?
  end
  
  def has_uploaded_thumbnail?
    !uploaded_thumbnail.nil?
  end  
  
  def require_upload_for_a_new_video
    errors.add :uploaded_file, "has to be provided" unless has_uploaded_file?
    Rails::logger.debug errors.to_hash
  end  
  
  def self.generate_random_code(len)
    (0...len).map{ ('a'..'z').to_a[rand(26)] }.join
  end
  
end
