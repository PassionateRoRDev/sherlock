require 'digest/md5'

class Picture < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
  
  def self.store(user, image)    
    FileAsset::store_for_type(user, image, 'pictures')            
  end  
  
  def delete_file
    delete_file_for_path(self.path, 'pictures')  
  end
  
  
  
end
