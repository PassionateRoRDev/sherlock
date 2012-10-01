require 'spec_helper'

describe Subscription do

  it "should be assignable to the users" do    
    chargify_id = 100    
    user = FactoryGirl.create(:user)   
    user.subscriptions << Subscription.create(:chargify_id => 100)
    Subscription.find_by_chargify_id(chargify_id).user.should == user
  end    
  
end