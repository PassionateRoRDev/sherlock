class Case < ActiveRecord::Base

  belongs_to :author, :class_name => 'User'
  has_and_belongs_to_many :viewers, :class_name => 'User', :join_table => 'viewers', :foreign_key => 'case_id', :association_foreign_key => 'viewer_id'

  belongs_to :folder
  
  has_many :blocks, :dependent => :destroy
  
  has_many :html_details, :through => :blocks
  has_many :pictures, :through => :blocks
  has_many :videos, :through => :blocks
  
  has_many :notes
  
  has_one :footer
  
  attr_accessible :title, :title_alignment,
                  :summary, :number, 
                  :client_name, 
                  :case_type,
                  :opened_on, :closed_on, :report_date
  
  scope :readable_by, lambda { |user| user.cases }
  scope :toplevel, where(:folder_id => nil)
  
  validates :title, :presence => true
  
  after_save :invalidate_report
  after_create :update_stats
  
  def usage
    blocks.empty? ? 0 : blocks.map(&:usage).reduce(:+)
  end
  
  def move_toplevel
    self.folder = nil
    save
  end
  
  def move_to_folder(folder)
    self.folder = folder
    save
  end
  
  def copy_picture(picture)
        
    uploader = UploaderFromResource.new(
      :content_type       => picture.content_type,
      :original_filename  => picture.original_filename,
      :filepath           => picture.full_filepath
    )
    
    block = Block.new
    block.picture = Picture.new do |p|
        p.unique_code       = Picture.generate_unique_code
        p.alignment         = picture.alignment
        p.title             = 'Copy of ' + picture.title
        p.uploaded_file     = uploader
    end    
    self.blocks << block
    
    block.picture.uploaded_file = nil
    
    block.picture    
  end
  
  def create_block_from_picture(picture, crop_params)    
    picture_copy = copy_picture(picture)
    if picture_copy            
      picture_copy.crop(crop_params)
      picture_copy.remove_backup            
    end      
    picture_copy   
  end
  
  def as_json(options = {})  
        
    except = [:author_id, :client_name, :id, :footer, :number, :updated_at]
    include = []    
    result = super(:include => include, :except => except)        
    
    result['titleAlignment'] = self.title_alignment
    
    result['blocks'] = self.blocks.map { |block| block.as_json(options) }    
    result
  end
  
   def create_event_for_creation
      exists = Event.where(
        :event_type     => 'create', 
        :event_subtype  => 'case', 
        :detail_i1 => self.id
      )
      if exists.empty?
        ev = Event.new(
            :event_type     => 'create',
            :event_subtype  => 'case',
            :detail_i1      => self.id,
            :user_id        => self.author_id
        )
        ev.started_at = self.created_at.to_i
        ev.save
      end
  end
  
  private
  
  def update_stats
    self.author.case_created(self)
  end
   
  def invalidate_report
    Report.invalidate_for_case self.id
  end
  
end
