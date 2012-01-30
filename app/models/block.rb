class Block < ActiveRecord::Base
  
  belongs_to :case
  
  has_one :html_detail, :dependent => :destroy    
  has_one :picture, :dependent => :destroy
  has_one :video, :dependent => :destroy
  
  default_scope :order => 'weight'
  
  def title
    result = 'Block'
    if self.html_detail
      result = 'Text Block'
    end
    if self.picture
      result = 'Picture Block'
    end
    if self.video
      result = 'Video Block'
    end
    result
    
  end
  
  def as_json(options = {})    
    
    include = []
    except = [:created_at, :updated_at, :id, :case_id]    
    result = super(:include => include, :except => except)
    
    options = {
      :except => [:id, :block_id, :updated_at, :created_at]
    }        
    
    if self.html_detail 
      result['htmlDetail'] = self.html_detail.as_json(options)
    end
    if self.video
      result['video'] = self.video.as_json(options)
    end
    if self.picture
      result['picture'] = self.picture.as_json(options)
    end
    result
  
  end
  
end
