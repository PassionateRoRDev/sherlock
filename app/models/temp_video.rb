class TempVideo

  include FileAssetUtils
  
  attr_accessor :user_id, :upload, :path
  
  def self.for_user(user)
    TempVideo.new { |v| v.user_id = user.id }
  end
  
  def self.get_upload_for_user(user)    
    for_user(user).uploaded_resource    
  end
  
  def self.remove_for_user(user)
    for_user(user).delete_if_exists
  end
  
  def initialize
    yield self if block_given?
  end    
  
  def author_id
    self.user_id
  end
  
  def file_type
    'tmp'
  end
      
  def uploaded_resource
    asset = self.exists?
    asset ? asset.uploaded_resource : nil    
  end
  
  def exists?
    FileAsset.find_by_user_id_and_role(self.user_id, :tmp)
  end
  
  def delete_if_exists
    asset_exists = self.exists?    
    asset_exists.destroy if asset_exists    
  end
  
  def save
    
    delete_if_exists
        
    #
    # TODO: at some point move 'store_from_source' into the after_save
    #       method of the FileAsset
    self.path = self.store_from_source(self.upload.original_filename, self.upload)
    
    FileAsset.create(                        
        :user_id      => self.user_id,
        :content_type => self.upload.content_type,
        :role         => :tmp,
        :parent_type  => :tmp,
        :path         => self.path,
        :filesize     => File.size(full_filepath)
      )    
  end
 
  
end
