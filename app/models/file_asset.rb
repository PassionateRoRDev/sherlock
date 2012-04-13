class FileAsset < ActiveRecord::Base
  
  include FileAssetUtils
  
  before_destroy :delete_file
  
  private
  
  # override from FileAssetUtils  
  def author_id
    self.user_id
  end
  
  # override from FileAssetUtils  
  def file_type
    parent_type
  end
  
  #
  # TODO: expand to S3
  #
  def delete_file    
    File.delete(full_filepath) if File.exists?(full_filepath)
  end
  
end
