class Logo < ActiveRecord::Base
    
  include FileAssetUtils
  include PictureAsset
  
  belongs_to :user
  belongs_to :letterhead
  belongs_to :storage
  
  has_many :file_assets, :foreign_key => 'parent_id', 
           :conditions => "parent_type = 'logos'", 
           :dependent => :destroy
  
  validate :require_upload_for_a_new_image, :unless => :persisted?
  validate :accept_only_image_uploads, :if => :has_uploaded_file?
    
  attr_accessor :uploaded_file  
  attr_accessor :original_filename # not really used right now
  
  before_save :process_upload, :if => :has_uploaded_file?  
  
  after_save :invalidate_reports
  
  after_save :generate_file_assets, :if => :has_uploaded_file?  
  
  before_destroy :delete_files
  before_destroy :invalidate_reports
            
  def file_type
    'logos'
  end
  
  def case_id
    0
  end    
  
  # Overrides author from FileAssetUtils
  def author
    self.user
  end
      
  def height_for_display(max_height)
    the_dims = dimensions
    the_dims == [0, 0] ? max_height : (the_dims[1] > max_height ? max_height : the_dims[1])
  end  
  
  def delete_files   
    if self.file_assets.empty?
      delete_file
      remove_original_file
    end
  end
  
  def move_to_storage(storage)    
    file_assets.each { |asset| asset.move_to_storage storage }
    self.storage = storage
    self.save
  end
  
  def generate_file_assets        
    if self.file_assets.empty?
      generate_main_asset      
      generate_orig_asset if File.exists?(orig_path)     
    end
  end

  private
    
  def invalidate_reports    
    Report.invalidate_for_user(self.letterhead.user_id) if self.letterhead        
  end
  
end
