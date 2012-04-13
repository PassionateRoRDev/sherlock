module PictureAsset

  require 'RMagick'
  
  def has_uploaded_file?
    !uploaded_file.nil?
  end
  
  def scale_to_height(png_bytes, dims, height)
    im = Magick::Image.from_blob(png_bytes).first
    new_height = height
    new_width = ((1.0 * new_height * dims[0]) / dims[1]).round    
    im.scale!(new_width, new_height)
    im.to_blob
  end  
  
  def dims
    dimensions
  end
  
  def dimensions
    File.exists?(full_filepath) ? Dimensions.dimensions(full_filepath) : [0, 0]
  end  
  
  def dimensions_for_bytes(bytes)
    stream = StringIO.new(bytes)
    dims = Dimensions(stream)
    stream.read
    [dims.width.to_i, dims.height.to_i]
  end
  
  def main_file_asset
    self.file_assets.find_by_role :main
  end
  
  def backup_file_asset
    self.file_assets.find_by_role :bak
  end
  
  def orig_file_asset
    self.file_assets.find_by_role :orig
  end
  
  
  def is_simple_image?(bytes)
    dims = dimensions_for_bytes(bytes)
    (dims[0] > 0) && (dims[1] > 0)    
  end
  
  def is_image?(bytes)
    case is_simple_image?(bytes)
    when true
      true
    when false
      begin
        Magick::Image.from_blob(bytes)
        true
      rescue Magick::ImageMagickError
        false
      end
    end
  end
  
  def orig_path
    full_path_for_suffix(:orig)
  end
  
  def remove_original_file
    File.delete(orig_path) if File.exists?(orig_path)
  end
  
  def orig_file_size
    file_size orig_path
  end  
  
  def convert_to_png(bytes)
    Magick::Image.from_blob(bytes).first.to_blob { |im| im.format = 'PNG' }
  end
  
  def store_as_original(bytes)
    File.open(orig_path, 'wb') { |f| f.write(bytes) }
  end
  
  # sum filesize of all the file assets
  def usage        
     file_assets.inject(0) { |sum, asset| sum + asset.filesize }
  end  
  
  def generate_main_asset
    FileAsset.create(        
        :parent_id    => self.id,
        :parent_type  => file_type,
        :user_id      => self.author_id,
        :content_type => self.content_type,
        :role         => :main,
        :path         => self.path,
        :filesize     => File.size(full_filepath)
      )      
  end
  
  def generate_orig_asset
    FileAsset.create(        
        :parent_id    => self.id,
        :parent_type  => file_type,
        :user_id      => self.author_id,
        :content_type => @original_content_type,
        :role         => :orig,
        :path         => path_for_suffix(:orig),
        :filesize     => File.size(orig_path)
    )      
  end
  
  def generate_backup_asset
    FileAsset.create(        
        :parent_id    => self.id,
        :parent_type  => file_type,        
        :user_id      => self.author_id,
        :content_type => self.content_type,
        :role         => :bak,
        :path         => self.path + '.bak',
        :filesize     => File.size(backup_path)
    )      
  end
  
  def process_upload
    
    @uploaded_file_bytes ||= uploaded_file.read
    
    effective_filename = uploaded_file.original_filename      
    content_type       = uploaded_file.content_type     
    
    @original_content_type = content_type
    
    # remove old files if it's an update (of the image)
    self.delete_files if persisted?
        
    self.original_filename = effective_filename
    self.content_type      = content_type
    
    bytes = @uploaded_file_bytes
    is_simple_image = is_simple_image? @uploaded_file_bytes
    
    needs_conversion = !is_simple_image    
    if needs_conversion
      bytes = convert_to_png(bytes)      
      content_type = 'image/png'
      effective_filename = path_for_suffix(:png, effective_filename)
    end
   
    self.content_type = content_type    
    self.path = store effective_filename, bytes
                
    store_as_original(@uploaded_file_bytes) if needs_conversion
  end
      
  def update_dims_and_save
    update_dims
    save
  end
  
  def update_dims        
    dims = self.dimensions    
    self.width  = dims.nil? ? 0 : dims[0]
    self.height = dims.nil? ? 0 : dims[1]        
  end
  
  #
  # Custom validators:
  #
  
  def require_upload_for_a_new_image    
    errors.add :uploaded_file, "has to be provided" unless has_uploaded_file?
    Rails::logger.debug errors.to_hash
  end
  
  def accept_only_image_uploads
    @uploaded_file_bytes ||= uploaded_file.read        
    errors.add :image_type, "could not be recognized" unless 
      is_image?(@uploaded_file_bytes)     
    Rails::logger.debug errors      
  end
  
end
