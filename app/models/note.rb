class Note < ActiveRecord::Base
  
  belongs_to :case
  
  attr_accessible :contents
  
end
