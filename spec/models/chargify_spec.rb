require 'spec_helper'

describe Chargify do 
  
  it "should create one-time charge using test site" do
    c = Sherlock::Chargify.new
    subscription_id = '1731908'
    c.charge(subscription_id, '1.00', 'Test one-time charge')
  end
    
end