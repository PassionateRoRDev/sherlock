class FileAsset < ActiveRecord::Base
  
  include FileAssetUtils
  
  attr_accessor :uploaded_file
  
  attr_accessible :uploaded_file, :parent_id, :parent_type, :user_id, :role
  
  before_create :process_upload, :if => :has_uploaded_file?
  
  before_destroy :delete_file
  
  def move_to_storage(s)
    
    old_path = full_filepath
    
    new_path = s ? base_dir_with_mount(File.join(s.mount_point, 'files')) : base_dir_with_mount(nil)
    
    new_path += ('/' + self.path)
    
    #pp "Moving:"
    #pp "old: #{old_path}"
    #pp "new: #{new_path}"
        
    new_dir = File.dirname(new_path)
    FileUtils.mkdir_p(new_dir) unless File.exists?(new_dir)
    
    FileUtils.mv(old_path, new_path)
    
  end
  
  def parent_class_name    
    case parent_type.to_sym
    when :videos
      Video      
    when :pictures
      Picture
    when :logos
      Logo
    when :documents
      Document
    end
  end
  
  def parent  
    parent_class_name ? parent_class_name.find_by_id(parent_id) : nil
  end
  
  def storage
    parent ? parent.storage : nil
  end
  
  def uploaded_resource
    UploaderFromResource.new(
      :content_type       => self.content_type,
      :original_filename  => recover_original_filename,
      :filepath           => full_filepath
    )    
  end
  
  def dimensions
    File.exists?(full_filepath) ? Dimensions.dimensions(full_filepath) : [0, 0]
  end  
  
  def copy_with_suffix(suffix)
    
  end
  
  private
  
  # override from FileAssetUtils  
  def author_id
    self.user_id
  end
  
  # override from FileAssetUtils  
  def file_type
    parent_type
  end
  
  #
  # TODO: expand to S3
  #
  def delete_file    
    #pp "deleting file_asset: path is" + full_filepath
    File.delete(full_filepath) if File.exists?(full_filepath)
  end
  
  def has_uploaded_file?
    !uploaded_file.nil?
  end
  
  def process_upload 
    
    @uploaded_file_bytes ||= uploaded_file.read    
    
    self.path = store uploaded_file.original_filename, @uploaded_file_bytes    
    
    self.content_type = uploaded_file.content_type
    self.filesize = File.size(full_filepath)    
    
  end  
  
end
