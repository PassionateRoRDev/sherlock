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
                  :client_name, :opened_on, :closed_on
  
  validates :title, :presence => true
  
  def as_json(options = {})  
        
    except = [:author_id, :client_name, :id, :footer, :number, :updated_at]
    include = []    
    result = super(:include => include, :except => except)        
    
    result['titleAlignment'] = self.title_alignment
    
    result['blocks'] = self.blocks.map { |block| block.as_json(options) }    
    result
  end
  
end
