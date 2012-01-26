require 'digest/md5'

class Video < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
    
  def file_type
    'videos'
  end
  
  def self.store(user, upload_info)    
    FileAsset::store_for_type(user, upload_info, 'videos')
  end    
  
  def delete_file
    delete_file_for_type(file_type)  
  end
  
  
  
end
