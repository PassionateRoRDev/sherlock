require 'RMagick'

class Logo < ActiveRecord::Base
    
  include FileAsset
  include PictureAsset
  
  belongs_to :user
  belongs_to :letterhead
  
  validate :require_upload_for_a_new_image, :unless => :persisted?
  validate :accept_only_image_uploads, :if => :has_uploaded_file?
    
  attr_accessor :uploaded_file  
  attr_accessor :original_filename # not really used right now
  
  before_save :process_upload, :if => :has_uploaded_file?
  after_save :invalidate_reports
  
  before_destroy :delete_files
  before_destroy :invalidate_reports
            
  def file_type
    'logos'
  end
  
  def case_id
    0
  end    
  
  # Overrides author from FileAsset  
  def author
    self.user
  end

  def height_for_display(max_height)
    the_dims = dimensions
    the_dims.nil? ? max_height : (the_dims[1] > max_height ? max_height : the_dims[1])
  end  
  
  def delete_files
    delete_file_for_type(file_type)
    remove_original_file   
  end  
  
  private
    
  def invalidate_reports    
    Report.invalidate_for_user(self.letterhead.user_id) if self.letterhead        
  end
  
end
