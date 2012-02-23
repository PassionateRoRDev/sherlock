require 'digest/md5'

class Picture < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  validates :path, :presence => true
  validates :title, :presence => true
  
  before_destroy :delete_file
  
  def self.scale_to_bounds(dims, max_dims)
    
    ratio = (0.0 + dims[0]) / dims[1]
    
    if (dims[0] > max_dims[0])
      dims[0] = max_dims[0]
      dims[1] = dims[0] / ratio
    end
    
    if (dims[1] > max_dims[1]) && (max_dims[1] > 0)
      dims[1] = max_dims[1]
      dims[0] = dims[1] * ratio
    end
    
    [ dims[0].round, dims[1].round ]
    
  end
  
  def self.store(author, upload_info)    
    FileAsset::store_for_type(author, upload_info, 'pictures')            
  end  
  
  def file_type
    'pictures'
  end
    
  def width_for_display(max_width)    
    dims = Dimensions.dimensions(full_filepath)
    dims ? (dims[0] > max_width ? max_width : dims[0]) : 0
  end
    
  def delete_file
    delete_file_for_type(file_type)  
  end
  
  def as_json(options = {})    
    options[:except] += [:original_filename, :content_type]
    result = super(options)        
    result['caption'] = result['title']
    
    dims = Dimensions.dimensions(full_filepath)
    result['width'] = dims[0]
    result['height'] = dims[1]
    
    result
  end 
 
end
