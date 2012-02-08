require 'digest/md5'

class Video < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
  before_destroy :delete_thumbnail
  
  def file_type
    'videos'
  end
  
  def thumbnail_method
    self.thumbnail_pos.blank? ? :manual : :auto
  end
  
  def self.store_thumbnail(user_id, video_filename, thumbnail_upload)
    
    thumbnail_upload.original_filename =~ /([^.]+)$/
    thumbnail_ext = $1
    thumbnail_filename = video_filename.sub(/([^.]+)$/, thumbnail_ext)
    #Rails::logger.debug('Thumbnail filename will be: ' + thumbnail_filename)
    full_thumbnail_path = FileAsset::dir_for_user(user_id, 'videos') + 
                          '/' + thumbnail_filename
    #Rails::logger.debug('Saving video thumbnail at ' + full_thumbnail_path)
    File.open(full_thumbnail_path, 'wb') {|f| f.write(thumbnail_upload.read) }
    
    thumbnail_dims = Dimensions.dimensions(full_thumbnail_path)
    
    {
      :filename => thumbnail_filename,
      :path     => full_thumbnail_path,
      :width    => thumbnail_dims[0],
      :height   => thumbnail_dims[1]
    }
  end
  
  def self.extract_thumbnail_from_movie(user_id, video_filename, thumb_timecode)
    
    Rails::logger.debug("extract_thumbnail_from_movie: " + user_id.to_s + ", " + video_filename)
    
    dir = FileAsset::dir_for_user(user_id, 'videos') + '/'
    thumbnail_ext = 'png'
    thumbnail_filename = video_filename.sub(/([^.]+)$/, thumbnail_ext)
    
    full_thumbnail_path = dir + thumbnail_filename      
    full_video_path = dir + video_filename
    
    timecode = thumb_timecode || 1
    
    command = "ffmpeg -vframes 1 -i #{full_video_path} -ss #{timecode} " +
              " -f image2 #{full_thumbnail_path} 2>/dev/null"
    
    Rails::logger.debug("Command is: " + command)
    result = `#{command}`
    Rails::logger.debug("Result of the command: " + result)    
    
    thumbnail_dims = Dimensions.dimensions(full_thumbnail_path)
    
    {
      :filename => thumbnail_filename,
      :path     => full_thumbnail_path,
      :width    => thumbnail_dims[0],
      :height   => thumbnail_dims[1]
    }    
    
  end  
  
  def self.store(user, upload_info)        
    FileAsset::store_for_type(user, upload_info, 'videos')                
  end
  
  def flv_path
    self.path.sub(/([^.]+)$/, 'flv')
  end
  
  def full_flv_path
    filepath_for_type_and_filename('videos', flv_path)        
  end
  
  def recode_to_flv    
    unless self.path == flv_path    
      video_path = filepath_for_type_and_filename('videos', self.path)
      new_video_path = full_flv_path
      command = "ffmpeg -i #{video_path} -deinterlace -ar 44100 -r 25 -qmin 3 -qmax 6 #{new_video_path}"
      Rails::logger.debug("Recode command: " + command)
      `#{command}`      
    end    
  end
  
  def rename_thumbnail
    user_id = self.block.case.user_id
    thumbnail_path = FileAsset::dir_for_user(user_id, 'videos') +  '/' +
                       self.thumbnail    
    thumbnail_path =~ /([^.]+)$/
    thumbnail_ext = $1
    
    new_thumbnail_filename = self.path.sub(/([^.]+)$/, thumbnail_ext)
    new_thumbnail_path = FileAsset::dir_for_user(user_id, 'videos') +  '/' +
                         new_thumbnail_filename
                         
    File.rename(thumbnail_path, new_thumbnail_path)
    self.thumbnail = new_thumbnail_filename
    
    Rails::logger.debug('Renamed ' + thumbnail_path + ', ' + new_thumbnail_path)
    
  end
  
  def delete_thumbnail
    Rails::logger.debug('Delete thumbnail: ' + self.thumbnail.to_s)
    if self.thumbnail
      user_id = self.block.case.user_id
      thumbnail_path = FileAsset::dir_for_user(user_id, 'videos') +  '/' +
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
    if flv_path 
      full_path = full_flv_path
      File.unlink(full_path) if File.exists?(full_path)
    end
  end
  
  def type_from_content_type(content_type)
    content_type ? content_type.split('/').last : ''    
  end
  
  def as_json(options = {})    
    options[:except] += [:original_filename]
    result = super(options)        
    result['caption'] = result['title']
    result['type']    = type_from_content_type(self.content_type)
    result
  end 
  
end
