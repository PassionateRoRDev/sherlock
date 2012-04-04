class Case < ActiveRecord::Base

  belongs_to :author, :class_name => 'User'
  has_and_belongs_to_many :viewers, :class_name => 'User', :join_table => 'viewers', :foreign_key => 'case_id', :association_foreign_key => 'viewer_id'

  has_many :blocks, :dependent => :destroy
  
  has_many :html_details, :through => :blocks
  has_many :pictures, :through => :blocks
  has_many :videos, :through => :blocks
  
  has_one :footer
  
  attr_accessible :title, :title_alignment,
                  :summary, :number, 
                  :client_name, 
                  :case_type,
                  :opened_on, :closed_on, :report_date
  
  validates :title, :presence => true
  
  after_save :invalidate_report
  
  def copy_picture(picture)
    
    filename = FileAsset::generate_new_filename(picture.original_filename)                
    full_dst_path = picture.filepath_for_type_and_filename('pictures', filename)
    FileUtils.copy_file(picture.full_filepath, full_dst_path)
    
    Picture.create(
      :block              => Block.new(:case => self),
      :unique_code        => Picture.generate_unique_code,      
      :title              => 'Copy of ' + picture.title,
      :path               => filename,
      :original_filename  => 'cropped-' + picture.original_filename,
      :content_type       => picture.content_type      
    )    
    
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
  
  def invalidate_report
    Report.invalidate_for_case self.id
  end
  
end
