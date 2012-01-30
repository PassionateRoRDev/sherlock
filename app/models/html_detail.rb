class HtmlDetail < ActiveRecord::Base
  belongs_to :block 
  validates :contents, :presence => true  
    
end
