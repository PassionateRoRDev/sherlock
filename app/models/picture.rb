class Picture < ActiveRecord::Base
  
  include BlockDetail  
  include PictureAsset
  
  # at some point we will remove it:
  include FileAssetUtils
      
  belongs_to :block  
  belongs_to :storage
  
  has_many :file_assets, :foreign_key => 'parent_id', 
           :conditions => "parent_type = 'pictures'", 
           :dependent => :destroy
  
  validates :title, :presence => true
  
  validate :require_upload_for_a_new_image, :unless => :persisted?
  validate :accept_only_image_uploads, :if => :has_uploaded_file?
  
  attr_accessor :uploaded_file
  
  attr_accessible :title, :uploaded_file, :alignment, :unique_code
    
  before_save :process_upload, :if => :has_uploaded_file?  
  before_save :update_dims, :if => :has_uploaded_file?
  
  before_destroy :delete_files  
  
  after_save :invalidate_report  
  after_save :generate_file_assets, :if => :has_uploaded_file?
  
  def self.generate(block)
    Picture.new do |p|
      p.block = block
      p.unique_code = generate_unique_code
    end        
  end
          
  def generate_file_assets
    if self.file_assets.empty?
      generate_main_asset
      generate_orig_asset if File.exists?(orig_path)
      generate_backup_asset if File.exists?(backup_path)        
    end
  end
    
  #
  # return path from the 'main' file asset
  #
  #def path
  #  main_file_asset.path
  #end    
  
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
  
  def file_type
    'pictures'
  end
    
  def backup    
    FileUtils.copy_file(full_filepath, backup_path)
    generate_backup_asset
  end
  
  def backup_path    
    full_filepath + '.bak'
  end
  
  def remove_backup
    File.delete(backup_path) if File.exists?(backup_path)
  end
  
  def restore_from_backup    
    File.rename(backup_path, full_filepath)    
    update_dims_and_save
    backup_file_asset.destroy if backup_file_asset
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
          update_dims_and_save
          update_filesize File.size(full_filepath)
          cropped = true
        end      
    end        
    cropped    
  end
  
  def move_to_storage(storage)
    file_assets.each { |asset| asset.move_to_storage storage }
  end
  
  def update_filesize(size)
    asset = main_file_asset
    asset.filesize = size
    asset.save
  end
    
  def width_for_preview
    width_for_display Report::MAX_PAGE_WIDTH
  end
  
  def width_for_display(max_width)    
    dims = dimensions
    dims ? (dims[0] > max_width ? max_width : dims[0]) : 0
  end
    
  def delete_files
    if self.file_assets.empty?
      delete_file
      remove_backup
      remove_original_file   
    else
      file_assets.destroy_all
    end
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
