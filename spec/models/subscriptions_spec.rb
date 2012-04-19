
describe Subscription do

  it "should be assignable to the users" do
    
    chargify_id = 100
    
    user = Factory(:user)    
    user.subscriptions << Factory(:subscription, :chargify_id => 100)
    Subscription.find_by_chargify_id(chargify_id).user.should == user
  end

  
end