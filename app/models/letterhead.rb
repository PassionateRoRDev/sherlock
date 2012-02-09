class Letterhead < ActiveRecord::Base
  
  belongs_to :user
  
  before_destroy :delete_logo
  
  include FileAsset
  
  def self.store_logo(user, upload_info)    
    FileAsset::store_for_type(user, upload_info, 'logos')            
  end
  
  def file_type
    'logos'
  end
  
  def path
    logo_path
  end
  
  # Overrides user_id from FileAsset
  def user_id
    self.user.id
  end
  
  def delete_logo
    delete_file_for_type(file_type)  
  end

  
end
