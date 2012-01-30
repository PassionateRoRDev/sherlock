class Case < ActiveRecord::Base

  belongs_to :user
  
  has_many :blocks, :dependent => :destroy
  
  has_many :html_details, :through => :blocks
  has_many :pictures, :through => :blocks
  has_many :videos, :through => :blocks
  
  validates :title, :presence => true
  
  def as_json(options = {})  
    
    except = [:user_id, :client_name, :id, :number, :updated_at]
    include = []    
    result = super(:include => include, :except => except)        
    result['blocks'] = self.blocks.map { |block| block.as_json }    
    result
  end
  
end
