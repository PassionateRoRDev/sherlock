class Logo < ActiveRecord::Base
    
  PNG_FROM_EPS_HEIGHT = 200
  
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
  
  def self.convert_eps_to_png(eps_bytes)
    Magick::Image.from_blob(eps_bytes).first.to_blob()
  end
  
  def self.scale_to_height(png_bytes, dims, height)
    im = Magick::Image.from_blob(png_bytes).first
    new_height = height
    new_width = ((1.0 * new_height * dims[0]) / dims[1]).round    
    im.scale!(new_width, new_height)
    im.to_blob
  end
  
  def self.dimensions_for_bytes(bytes)
    FileAsset::dimensions_for_bytes(bytes)
  end
  
  def self.store(author, upload_info)
    
    bytes = upload_info.read  
    if is_image?(bytes)       
      FileAsset::store_for_type(author, upload_info, bytes, 'logos')      
    elsif is_eps?(bytes)
      
      png_bytes = convert_eps_to_png(bytes)
      png_dims = dimensions_for_bytes(png_bytes)      
      png_bytes = scale_to_height(png_bytes, png_dims, PNG_FROM_EPS_HEIGHT) if
        png_dims[1] > PNG_FROM_EPS_HEIGHT
      
      
      upload_info.content_type = 'image/png'
      upload_info.original_filename = 
        path_for_format(upload_info.original_filename, :png)      
      png_path = FileAsset::store_for_type(author, upload_info, png_bytes, 'logos')        
      eps_path = path_for_format(png_path, :eps)
      full_eps_path = 
        FileAsset::filepath_for_type_filename_and_author('logos', eps_path, author.id)          
      File.open(full_eps_path, 'wb').write(bytes)
      png_path
    else
      nil
    end
  end
  
  def self.is_eps?(bytes)
    bytes[0..3] = "%!PS"
  end
  
  def eps_path
    path_for_format(:eps)
  end
  
  def self.path_for_format(path, format)
    path.sub(/([^.]+)$/, format.to_s)
  end
  
  def path_for_format(format)
    Logo.path_for_format(self.path, format)        
  end
  
  def full_path_for_format(format)
    filepath_for_type_and_filename(file_type, path_for_format(format))        
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
  
  def delete_file_for_format(format)
    full_path = full_path_for_format(format)
    File.unlink(full_path) if File.exists?(full_path)
  end
  
  def delete_file
    delete_file_for_type(file_type)
    [:eps].each { |format| delete_file_for_format(format) }          
  end
  
end
