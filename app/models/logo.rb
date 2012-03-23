class Logo < ActiveRecord::Base
    
  include FileAsset
  
  belongs_to :user
  belongs_to :letterhead
  
  validates :path, :presence => true
  
  before_destroy :delete_file    
  
  #
  # TODO: extend the FileAsset module
  #
  def self.is_image?(bytes)
    FileAsset::is_image?(bytes)
  end
  
  def self.store(author, upload_info)
    bytes = upload_info.read
    if is_image?(bytes)
      FileAsset::store_for_type(author, upload_info, bytes, 'logos')            
    else
      nil
    end
  end  
  
  def file_type
    'logos'
  end
  
  def case_id
    0
  end
  
  # Overrides author_id from FileAsset
  def author_id
    self.user.id
  end  

  def has_file?
    File.exists?(full_filepath.to_s)
  end
  
  def dims
    has_file? ? Dimensions.dimensions(full_filepath) : nil  
  end
  
  def height_for_display(max_height)
    the_dims = dims
    the_dims.nil? ? max_height : (the_dims[1] > max_height ? max_height : the_dims[1])
  end  
  
  def delete_file
    delete_file_for_type(file_type)  
  end
  
end
