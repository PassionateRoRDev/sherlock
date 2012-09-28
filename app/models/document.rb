class Document < ActiveRecord::Base
    
  belongs_to :case  
  belongs_to :storage
  
  has_many :file_assets, :foreign_key => 'parent_id', 
           :conditions => "parent_type = 'documents'", 
           :dependent => :destroy
  
  attr_accessor :uploaded_file
  attr_accessible :title, :case, :uploaded_file
  
  before_save :upload_before_save, :if => :has_uploaded_file?
  after_save :upload_after_save, :if => :has_uploaded_file?
  
  def file_type
    'documents'
  end
  
  def author
    self.case.author
  end
          
  private
    
  def delete_files
    file_assets.destroy_all unless file_assets.empty?    
  end
  
  def has_uploaded_file?
    !uploaded_file.nil?
  end
  
  def upload_before_save
    delete_files if persisted?
    store_original_filename
  end
  
  def upload_after_save    
    generate_file_assets    
  end
  
  def store_original_filename    
    self.original_filename = uploaded_file.original_filename
  end
  
  def generate_file_assets
                
    FileAsset.create(  
        :uploaded_file  => uploaded_file,
        :parent_id      => self.id,
        :parent_type    => :documents,
        :user_id        => self.author.id,        
        :role           => :orig        
      ) 
  end
  
  
end
