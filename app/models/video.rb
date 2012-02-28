require 'digest/md5'
require 'zip/zip'

class Video < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
  before_destroy :delete_thumbnail
  
  def self.generate(block)
    Video.new(
      :block          => block,
      :unique_code    => generate_unique_code,
      :thumbnail_pos  => '00:00:01'
    )
  end
  
  def file_type
    'videos'
  end
  
  def thumbnail_method
    self.thumbnail_pos.blank? ? :manual : :auto
  end
  
  def width_for_display(max_width)    
    width > max_width ? max_width : width
  end  
  
  def online_dims
    max_width = 750
    min_width = 450
    result = Picture.scale_to_bounds([width, height], [max_width, 0])
    ratio = (0.0 + result[1]) / result[0]
    if result[0] < min_width
      result[0] = min_width
      result[1] = (ratio * result[0]).round
    end
    result
  end
  
  def self.store_thumbnail(author_id, video_filename, thumbnail_upload)
    
    thumbnail_upload.original_filename =~ /([^.]+)$/
    thumbnail_ext = $1
    thumbnail_filename = video_filename.sub(/([^.]+)$/, thumbnail_ext)
    #Rails::logger.debug('Thumbnail filename will be: ' + thumbnail_filename)
    full_thumb_path = FileAsset::dir_for_author(author_id, 'videos') + 
                          '/' + thumbnail_filename
    #Rails::logger.debug('Saving video thumbnail at ' + full_thumb_path)
    File.open(full_thumb_path, 'wb') {|f| f.write(thumbnail_upload.read) }
    
    thumbnail_dims = Dimensions.dimensions(full_thumb_path)
    
    {
      :filename => thumbnail_filename,
      :path     => full_thumb_path,
      :width    => thumbnail_dims[0],
      :height   => thumbnail_dims[1]
    }
  end
    
  def self.extract_thumbnail_from_movie(author_id, video_filename, thumb_timecode)
    
    Rails::logger.debug("extract_thumbnail_from_movie: " + author_id.to_s + ", " + video_filename)
    
    is_zip = video_filename.end_with?('zip')
    
    dir = FileAsset::dir_for_author(author_id, 'videos') + '/'
    thumbnail_ext     = is_zip ? 'jpg' : 'png'    
    thumbnail_filename = video_filename.sub(/([^.]+)$/, thumbnail_ext)
    
    full_thumb_path = dir + thumbnail_filename      
    full_video_path = dir + video_filename
    
    timecode = thumb_timecode || 1
    
    if is_zip
      Rails::logger.debug("Opening the zip file")
      Zip::ZipFile.open(full_video_path) do |zip_file|
        zip_file.each do |frame|
          Rails::logger.debug("Extracting frame to #{full_thumb_path}")
          zip_file.extract(frame, full_thumb_path)
          break
        end                
      end
    else
      command = "ffmpeg -vframes 1 -i #{full_video_path} -ss #{timecode} " +
              " -f image2 #{full_thumb_path} 2>/dev/null"
    
      Rails::logger.debug("Command is: " + command)
      result = `#{command}`
      Rails::logger.debug("Result of the command: " + result)
    end            
    
    thumbnail_dims = Dimensions.dimensions(full_thumb_path)
    
    {
      :filename => thumbnail_filename,
      :path     => full_thumb_path,
      :width    => thumbnail_dims[0],
      :height   => thumbnail_dims[1]
    }    
    
  end  
  
  def self.store(author, upload_info)        
    FileAsset::store_for_type(author, upload_info, 'videos')                
  end
  
  def self.encode(author_id, zip_filename)
    
    Rails::logger.debug("Encoding: zip_filename = " + zip_filename)
    author_videos_dir = FileAsset::dir_for_author(author_id, 'videos')
    
    full_zip_path = author_videos_dir + '/' + zip_filename
    
    Rails::logger.debug("Full zip path = " + full_zip_path)
    destination = full_zip_path + '_frames'
    Rails::logger.debug("Destination = " + destination)
    FileUtils.mkdir_p(destination) unless File.directory?(destination)
    
    Zip::ZipFile.open(full_zip_path) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(destination, f.name)     
        zip_file.extract(f, f_path)
      end
    end
    
    video_filename = zip_filename.sub(/([^.]+)$/, 'mp4')
    video_full_path = author_videos_dir + '/' + video_filename
    
    command = "ffmpeg -r 15 -b 1800 -i #{destination}/%06d.jpg #{video_full_path}"
    Rails::logger.debug("Command: #{command}")
    
    result = `#{command}`
    Rails::logger.debug("Result of the command: " + result)
    
    # remove the zip & frame images (whole dir)
    File.unlink(full_zip_path)
    FileUtils.rm_rf(destination)
    
    video_filename
  
  end
  
  def full_thumbnail_path
    filepath_for_type_and_filename(file_type, thumbnail)    
  end  
  
  def path_for_format(format)
    self.path.sub(/([^.]+)$/, format.to_s)
  end
  
  def flv_path
    path_for_format(:flv)
  end
  
  def m4v_path
    path_for_format(:m4v)
  end
  
  def full_path_for_format(format)
    filepath_for_type_and_filename('videos', path_for_format(format))        
  end
  
  def recode_to(formats)    
    video_path = filepath_for_type_and_filename('videos', self.path)
    formats.each do |format|      
      unless self.path == path_for_format(format)        
        new_video_path = full_path_for_format(format)
        extra_flags = ''
        if format == :m4v
          extra_flags += ' -vprofile baseline'
        end
        command = "ffmpeg -i #{video_path} #{extra_flags} -strict experimental -deinterlace -ar 44100 -y -r 25 -qmin 3 -qmax 6 #{new_video_path}"
        Rails::logger.debug("Recode command: " + command)
        `#{command}`      
      end
    end
  end
  
  def rename_thumbnail
    author_id = self.block.case.author_id
    thumbnail_path = FileAsset::dir_for_author(author_id, 'videos') +  '/' +
                       self.thumbnail    
    thumbnail_path =~ /([^.]+)$/
    thumbnail_ext = $1
    
    new_thumbnail_filename = self.path.sub(/([^.]+)$/, thumbnail_ext)
    new_thumbnail_path = FileAsset::dir_for_author(author_id, 'videos') +  '/' +
                         new_thumbnail_filename
                         
    File.rename(thumbnail_path, new_thumbnail_path)
    self.thumbnail = new_thumbnail_filename
    
    Rails::logger.debug('Renamed ' + thumbnail_path + ', ' + new_thumbnail_path)
    
  end
  
  def delete_thumbnail
    Rails::logger.debug('Delete thumbnail: ' + self.thumbnail.to_s)
    if self.thumbnail
      author_id = self.block.case.author_id
      thumbnail_path = FileAsset::dir_for_author(author_id, 'videos') +  '/' +
                       self.thumbnail
      File.unlink(thumbnail_path) if File.exists?(thumbnail_path)
    end
  end
  
  def delete_file_for_path(filename)    
    path = filepath_for_type_and_filename('videos', filename)
    File.unlink(path) if File.exists?(path)    
  end
  
  def delete_file
    delete_file_for_type(file_type)
    [:flv, :m4v].each do |format|        
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
  
  def self.generate_random_code(len)
    (0...len).map{ ('a'..'z').to_a[rand(26)] }.join
  end
  
end
