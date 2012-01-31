require 'digest/md5'

class Video < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
    
  def file_type
    'videos'
  end
  
  def self.store(user, upload_info, thumbnail_upload)    
    video_filename = FileAsset::store_for_type(user, upload_info, 'videos')
    Rails::logger.debug('Video path is: ' + video_filename.to_s)
    thumbnail_filename = nil
    if thumbnail_upload
      # store the thumbnail image as well
      thumbnail_upload.original_filename =~ /([^.]+)$/
      thumbnail_ext = $1
      thumbnail_filename = video_filename.sub(/([^.]+)$/, thumbnail_ext)
      Rails::logger.debug('Thumbnail filename will be: ' + thumbnail_filename)
      full_thumbnail_path = FileAsset::dir_for_user(user.id, 'videos') + 
                            '/' + thumbnail_filename
      Rails::logger.debug('Saving video thumbnail at ' + full_thumbnail_path)
      File.open(full_thumbnail_path, 'wb') {|f| f.write(thumbnail_upload.read) }
    end
    {
      :video_filename     => video_filename,
      :thumbnail_filename => thumbnail_filename
    }
  end    
  
  def delete_file
    delete_file_for_type(file_type)  
    # delete thumbnail if one is present
    if self.thumbnail
      user_id = self.block.case.user_id
      thumbnail_path = FileAsset::dir_for_user(user_id, 'videos') + 
        '/' + self.thumbnail
      File.unlink(thumbnail_path) if File.exists?(thumbnail_path)
    end
  end
  
  def as_json(options = {})    
    options[:except] += [:original_filename]
    result = super(options)        
    result['caption'] = result['title']
    result
  end 
  
end
