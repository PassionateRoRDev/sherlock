class BlockTypes::WitnessStatement < ActiveRecord::Base
  
  include BlockDetail
  
  belongs_to :block
  
  belongs_to :block 
  
  after_save :invalidate_report
  
  attr_accessible :day, :time, 
                  :name, :address, :city, :state, :zip,
                  :contents
                
end
