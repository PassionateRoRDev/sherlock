require 'digest/md5'
require 'RMagick'

class Picture < ActiveRecord::Base
  
  include BlockDetail
  include FileAsset  
  include PictureAsset
  
  belongs_to :block 
  
  validates :title, :presence => true
  
  validate :require_upload_for_a_new_image, :unless => :persisted?
  validate :accept_only_image_uploads, :if => :has_uploaded_file?
  
  attr_accessor :uploaded_file
  
  attr_accessible :title, :uploaded_file, :alignment, :unique_code
  
  before_save :process_upload, :if => :has_uploaded_file?  
  before_destroy :delete_files  
  after_save :invalidate_report
  
  def self.generate(block)
    Picture.new do |p|
      p.block = block
      p.unique_code = generate_unique_code
    end        
  end
  
  #
  # The picture block may contain:
  # - the original file
  # - the 'current' version of the file
  # - the backup copy
  #
  def usage        
     file_size + backup_size + orig_file_size    
  end
    
  def backup_size
    file_size backup_path    
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

    return max_dims if dims.nil? || dims[0].nil? || dims[1].nil?
    
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
      
  def file_type
    'pictures'
  end
    
  def backup
    FileUtils.copy_file(full_filepath, backup_path)
  end
  
  def backup_path
    full_filepath + '.bak'
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
    
  def width_for_preview
    width_for_display Report::MAX_PAGE_WIDTH
  end
  
  def width_for_display(max_width)    
    dims = dimensions
    dims ? (dims[0] > max_width ? max_width : dims[0]) : 0
  end
    
  def delete_files
    delete_file
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
  
end
