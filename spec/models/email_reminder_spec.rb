require 'spec_helper'

describe EmailReminder do
  
  context 'if all subscriptions finish tomorrow' do
    before do
      @reminder = EmailReminder.new
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:subscription, 
        :user => @user,
        :product_handle => :free_trial,
        :period_ends_at => Time.now + 1.day
      )          
    end    
    it "should not send any reminders" do            
      @reminder.process_free_trial_1_week_left
      @reminder.process_free_trial_4_days_left
      @reminder.process_free_trial_expire_today
      ActionMailer::Base.deliveries.should be_empty
    end
  end
  
  context "if 4 days left" do
    before do
      @reminder = EmailReminder.new
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:subscription, 
        :user => @user,
        :product_handle => :free_trial,
        :period_ends_at => Time.now + 4.days
      )            
    end
  
    it "should send 1 reminder to the user" do    
      @reminder.process_free_trial_4_days_left
      ActionMailer::Base.deliveries.should_not be_empty
    end  
    it "should use correct subject line" do    
      email = @reminder.process_free_trial_4_days_left.first
      email.subject.should include '4 days left'
    end  
    
    it "should not send the same email twice to the user" do
      @reminder.process_free_trial_4_days_left
      @reminder.process_free_trial_4_days_left.should be_empty
    end
    
  end
  
  context "for subscriptions expiring today" do
    before do
      @reminder = EmailReminder.new
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:subscription, 
        :user => @user,
        :product_handle => :free_trial,
        :period_ends_at => Time.now.beginning_of_day + 10.hours
      )            
    end
    
    it "should send 1 email with appropriate subject" do
      email = @reminder.process_free_trial_expire_today.first
      email.subject.should include 'expiring today'
    end
    
    it "should not send the same email twice to the user" do
      @reminder.process_free_trial_expire_today
      @reminder.process_free_trial_expire_today.should be_empty
    end
    
  end
  
  context "for weekly reminders" do
  
    before do
      @reminder = EmailReminder.new
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:subscription, 
        :user => @user,
        :product_handle => :free_trial,
        :period_ends_at => Time.now + 1.week
      )            
    end
  
    it "should send 1 weekly reminder to user" do    
      @reminder.process_free_trial_1_week_left    
      ActionMailer::Base.deliveries.should_not be_empty    
    end  

    it "should use correct subject line" do                      
      email = @reminder.process_free_trial_1_week_left.first            
      email.subject.should include '1 week left'      
    end  
    
    it "should not send the same email twice to the user" do
      @reminder.process_free_trial_1_week_left
      @reminder.process_free_trial_1_week_left.should be_empty
    end
    
  end
  
end