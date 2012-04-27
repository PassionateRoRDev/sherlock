class FileAsset < ActiveRecord::Base
  
  include FileAssetUtils
  
  before_destroy :delete_file
  
  def uploaded_resource
    UploaderFromResource.new(
      :content_type       => self.content_type,
      :original_filename  => recover_original_filename,
      :filepath           => full_filepath
    )    
  end
  
  def dimensions
    File.exists?(full_filepath) ? Dimensions.dimensions(full_filepath) : [0, 0]
  end  
  
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
    #pp "deleting file_asset: path is" + full_filepath
    File.delete(full_filepath) if File.exists?(full_filepath)
  end
  
end
