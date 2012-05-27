require 'spec_helper'

describe Chargify::EventsController do
  
  describe "POST 'create'" do
    
    def body_from_payload(subscription_payload)
        'event=subscription_state_change' +
        "&payload[subscription][id]=#{subscription_payload[:id]}" +
        "&payload[subscription][current_period_ends_at]=#{subscription_payload[:current_period_ends_at]}" +
        "&payload[subscription][state]=#{subscription_payload[:state]}"
    end      
    
    def post_for_payload(subscription_payload)
      
      body = body_from_payload(subscription_payload)
        
      signature = ::Sherlock::Chargify.new.calculate_webhook_signature(body)    

      @request.env['HTTPS'] = 'on'      
      @request.env['RAW_POST_DATA'] = body

      post 'create', 
        :signature  => signature,
        :payload    => { :subscription => subscription_payload }        
    end
    
    context "update of the subscription to an active state" do
            
      before do
        
        @subscription = Factory(:subscription)            
        
        subscription_payload = {
          :id => @subscription.chargify_id,
          :current_period_ends_at => 'Sun Jun 24 20:52:44 UTC 2012',
          :state => :active
        }
        
        post_for_payload(subscription_payload)
                
      end      
        
      it "should update the current subscription to active" do      
        @subscription.user.current_subscription.status.should == "active"      
      end

      it "should extend the current subscription" do      
        @subscription.user.current_subscription.period_ends_at.should == Time.parse("Sun Jun 24 20:52:44 UTC 2012")   
      end
      
      it "should create a new subscription record" do
        @subscription.user.subscriptions.count.should == 2
      end
      
    end
    
    context "update of the subscription to an canceled state (same period)" do
            
      before do        
        @subscription = Factory(:subscription)                    
        subscription_payload = {
          :id => @subscription.chargify_id,
          :current_period_ends_at => 'Tue May 1 01:00:00 UTC 2012',
          :state => :canceled
        }        
        post_for_payload(subscription_payload)                
      end      
        
      it "should update the current subscription to canceled" do      
        @subscription.user.current_subscription.status.should == "canceled"      
      end

      it "should not create a new subscription record" do
        @subscription.user.subscriptions.count.should == 1
      end
      
    end
    
    context "update of the subscription to an canceled state (new period)" do
            
      before do        
        @subscription = Factory(:subscription)                    
        subscription_payload = {
          :id => @subscription.chargify_id,
          :current_period_ends_at => 'Sun Jun 24 20:52:44 UTC 2012',
          :state => :canceled
        }        
        post_for_payload(subscription_payload)                
      end      
        
      it "should make the current subscription become canceled" do      
        @subscription.user.current_subscription.status.should == "canceled"      
      end

      it "should create a new subscription record" do
        @subscription.user.subscriptions.count.should == 2
      end
      
    end
    
  end
  
end