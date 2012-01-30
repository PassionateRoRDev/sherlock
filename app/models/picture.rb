require 'digest/md5'

class Picture < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true  
  
  before_destroy :delete_file
  
  def self.store(user, upload_info)    
    FileAsset::store_for_type(user, upload_info, 'pictures')            
  end  
  
  def file_type
    'pictures'
  end
    
  def delete_file
    delete_file_for_type(file_type)  
  end
  
  def as_json(options = {})    
    options[:except] += [:original_filename, :content_type]
    result = super(options)        
    result['caption'] = result['title']
    result
  end 
 
end
