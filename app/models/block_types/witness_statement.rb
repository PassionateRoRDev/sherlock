class BlockTypes::WitnessStatement < ActiveRecord::Base
  
  include BlockDetail
  
  belongs_to :block
  
  belongs_to :block 
  
  after_save :invalidate_report
  
  attr_accessible :day, :hour, 
                  :name, :address, :city_state_zip,
                  :contents
                
  def as_json(options = {})
    postprocess(super(options))
  end
  
  def postprocess(json)   
    json.merge('cityStateZip' => json['city_state_zip'])
  end
  
end
