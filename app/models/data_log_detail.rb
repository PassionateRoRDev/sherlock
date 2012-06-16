class DataLogDetail < ActiveRecord::Base  
  
  include BlockDetail
  
  belongs_to :block 
  validates :contents, :presence => true  

  after_save :invalidate_report
  
  attr_accessible :contents, :day, :hour, :location
  
end
