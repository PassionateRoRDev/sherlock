class Block < ActiveRecord::Base
  
  belongs_to :case  
  has_one :html_detail, :dependent => :destroy    
  has_one :picture, :dependent => :destroy
  
  default_scope :order => 'weight'
  
end
