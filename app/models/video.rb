require 'digest/md5'

class Video < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
  
  def self.store(user, image)    
    FileAsset::store_for_type(user, image, 'videos')            
  end  
  
  def delete_file
    delete_file_for_path(self.path, 'videos')  
  end
  
  
  
end
