class Block < ActiveRecord::Base
  
  belongs_to :case
  
  has_one :html_detail, :dependent => :destroy    
  has_one :picture, :dependent => :destroy
  has_one :video, :dependent => :destroy
  
  before_create :initialize_weight
  
  before_destroy :adjust_weights
  
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
  
  private
  
  def initialize_weight
    self.weight = self.case.blocks.maximum('weight').to_i + 1
  end
  
  def adjust_weights
    case_id = self.case.id.to_i
    weight  = self.weight.to_i
    Block.connection.update(
      "UPDATE blocks SET weight = weight - 1 
       WHERE case_id = #{case_id} AND weight >= #{weight}")
  end
  
end
