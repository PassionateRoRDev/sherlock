require 'spec_helper'

describe Chargify do 
  
  it "should create one-time charge using test site" do
    #c = Sherlock::Chargify.new
    #subscription_id = '1731908'
    #c.charge(subscription_id, '1.00', 'Test one-time charge')
  end
  
  it "should calculate proper signature for a webhook request" do
    
    body = "payload[chargify]=testing&event=test"
    c = Sherlock::Chargify.new
    c.calculate_webhook_signature(body).should == "54a138396bff5ace4c2356df6a77fa37"
    
  end
    
end