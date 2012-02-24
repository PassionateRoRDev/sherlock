class Logo < ActiveRecord::Base
    
  include FileAsset
  
  belongs_to :user
  belongs_to :letterhead
  
  before_destroy :delete_file    
  
  def self.store(author, upload_info)    
    FileAsset::store_for_type(author, upload_info, 'logos')            
  end  
  
  def file_type
    'logos'
  end
  
  # Overrides author_id from FileAsset
  def author_id
    self.user.id
  end  

  def dims
    File.exists?(full_filepath) ? Dimensions.dimensions(full_filepath) : nil  
  end
  
  def height_for_display(max_height)
    the_dims = dims
    the_dims[1] > max_height ? max_height : the_dims[1]
  end  
  
  def delete_file
    delete_file_for_type(file_type)  
  end
  
end
