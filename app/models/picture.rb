require 'digest/md5'

class Picture < ActiveRecord::Base
  
  include FileAsset
  
  belongs_to :block 
  
  validates :title, :presence => true
  
  validate :accept_only_image_uploads, :if => :has_uploaded_file?
  
  attr_accessor :uploaded_file
  
  attr_accessible :title, :uploaded_file, :alignment, :unique_code
  
  before_save :process_upload, :if => :has_uploaded_file?
  
  before_destroy :delete_files
  
  def self.generate(block)
    Picture.new do |p|
      p.block = block
      p.unique_code = generate_unique_code
    end        
  end
  
  def online_dims
    
    max_width = Report::MAX_PAGE_WIDTH
    min_width = 450
    
    dims = dimensions
    
    return dims if (dims == [0, 0]) || (dims[0] <= max_width)
            
    result = Picture.scale_to_bounds([dims[0], dims[1]], [max_width, 0])
    ratio = (0.0 + result[1]) / result[0]
    if result[0] < min_width
      result[0] = min_width
      result[1] = (ratio * result[0]).round
    end
    result
  end
  
  def self.scale_to_bounds(dims, max_dims)

    return max_dims if dims.nil?
    
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
  
  #
  # TODO: extend the FileAsset module
  # TODO: OR remove it from FileAsset altogether
  #
  def self.is_image?(bytes)
    FileAsset::is_image?(bytes)
  end
  
  def self.is_simple_image?(bytes)
    FileAsset::is_simple_image?(bytes)
  end
  
  def self.store(author, upload_info)
    bytes = upload_info.read  
    if is_image?(bytes)
      FileAsset::store_for_type(author, upload_info, bytes, 'pictures') 
    else
      nil
    end
  end  
  
  def case_id
    block ? block.case_id : 0
  end
  
  def file_type
    'pictures'
  end
  
  def has_uploaded_file?
    !uploaded_file.nil?
  end
  
  def backup
    FileUtils.copy_file(full_filepath, backup_path)
  end
  
  def backup_path
    full_filepath + '.bak'
  end
  
  def orig_path
    full_path_for_suffix(:orig)
  end
  
  def remove_original_file
    File.delete(orig_path) if File.exists?(orig_path)
  end
  
  def remove_backup
    File.delete(backup_path) if File.exists?(backup_path)
  end
  
  def restore_from_backup
    File.rename(backup_path, full_filepath)
  end
    
  def crop(rectangle)   
    
    cropped = false
    
    x, y, w, h = rectangle
    
    cropper = Cropper.new
    result = cropper.crop(full_filepath, x, y, w, h)    
    
    # sanity check - the result must exist and its dimensions have to match
    # the desired ones:
    
    if result.present? && File.exists?(result)
        if Dimensions.dimensions(result) == [w.to_i, h.to_i]          
          backup
          File.rename(result, full_filepath)
          cropped = true
        end      
    end
        
    cropped
    
  end
  
  def dimensions
    File.exists?(full_filepath) ? Dimensions.dimensions(full_filepath) : [0, 0]
  end
  
  def width_for_preview
    width_for_display Report::MAX_PAGE_WIDTH
  end
  
  def width_for_display(max_width)    
    dims = dimensions
    dims ? (dims[0] > max_width ? max_width : dims[0]) : 0
  end
    
  def delete_files
    delete_file_for_type(file_type)
    remove_backup
    remove_original_file    
  end

  def self.populate_missing_codes
    Picture.where(:unique_code => nil).each do |pic|
      pic.unique_code = Picture.generate_unique_code
      pic.save
    end
    Picture.where(:unique_code => '').each do |pic|
      pic.unique_code = Picture.generate_unique_code
      pic.save
    end
  end
  
  def as_json(options = {}) 
    
    options[:except] ||= []
    
    options[:except] += [:original_filename, :content_type]
    result = super(options)
        
    result['caption'] = result['title']
    
    dims = dimensions
    result['width'] = dims[0]
    result['height'] = dims[1]
    
    result
  end
  
  def self.generate_unique_code
    len = 10
    code = ''
    until code.present? && (!Picture.find_by_unique_code(code))
      code = generate_random_code(len)
    end
    code    
  end
  
  private
  
  def self.generate_random_code(len)
    (0...len).map{ ('a'..'z').to_a[rand(26)] }.join
  end
 
  def convert_to_png(bytes)
    Magick::Image.from_blob(bytes).first.to_blob { |im| im.format = 'PNG' }
  end
  
  def process_upload
    
    @uploaded_file_bytes ||= uploaded_file.read
      
    effective_filename = uploaded_file.original_filename      
    content_type       = uploaded_file.content_type     
    
    # remove the old files if persisted
    self.delete_files if persisted?
        
    self.original_filename = effective_filename
    self.content_type      = content_type
    
    bytes = @uploaded_file_bytes
    is_simple_image = Picture.is_simple_image? @uploaded_file_bytes
    unless is_simple_image 
      bytes = convert_to_png(bytes)      
      self.content_type = 'image/png'
      effective_filename = path_for_suffix(:png, effective_filename)
    end
   
    self.content_type = content_type    
    self.path = store effective_filename, bytes
        
    # store the original file under .orig if we did any conversions    
    File.open(orig_path, 'wb').write(@uploaded_file_bytes) unless is_simple_image  
    
  end
  
  #
  # Custom validator:
  #
  def accept_only_image_uploads
    @uploaded_file_bytes ||= uploaded_file.read        
    errors.add :image_type, "Invalid image type" unless 
      Picture.is_image?(@uploaded_file_bytes)     
  end
  
end
