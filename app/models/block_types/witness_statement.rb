class BlockTypes::WitnessStatement < ActiveRecord::Base
  
  include BlockDetail
  
  belongs_to :block
  
  belongs_to :block 
  
  after_save :invalidate_report
  
  attr_accessible :day, :hour, 
                  :name, :address, :city_state_zip,
                  :contents
                
end
