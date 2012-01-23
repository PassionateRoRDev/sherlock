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
  
end
