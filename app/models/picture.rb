class Picture < ActiveRecord::Base
  belongs_to :block 
  validates :path, :presence => true  
  
end
