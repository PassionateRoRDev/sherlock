require 'spec_helper'

describe PostOffice do
  
  context "For the sample report email" do
    before do
      email = 'user1@mail.com'
      link_signup = 'http://sherlockdocs.com/signup'
      @presenter = SampleReportPresenter.new(email, link_signup)
    end
    
    it "should send proper email" do      
      email = PostOffice.sample_report(@presenter).deliver              
      #pp email.parts[0].body
      #pp email.parts[1].body      
    end
  end
  
  context "For the welcome email" do
    
    before do    
      user = FactoryGirl.create(:user)
      user.password_plain = 'ABCDEFGH'
      @presenter = SignupPresenter.new(user)
    end
        
    it "should contain first name and last name in the greeting" do
      email = PostOffice.welcome(@presenter).deliver
      #pp email.parts[0].body
      #pp email.parts[1].body      
    end
    
  end
  
  context "For the 1-week left of free_trial email" do
    before do
      user = FactoryGirl.create(:user)
      @presenter = FreeTrialPresenter.new(user)
    end
    
    it "should contain user's first name" do
      email = PostOffice.free_trial_1_week(@presenter).deliver
      email.parts[0].body.should include 'Dear John,'
    end    
  end
  
  context "For the 4-days left of free_trial email" do
    before do
      user = FactoryGirl.create(:user)
      @presenter = FreeTrialPresenter.new(user)
    end
    
    it "should contain user's first name" do
      email = PostOffice.free_trial_4_days(@presenter).deliver      
      email.parts[0].body.should include 'Dear John,'            
    end    
  end
  
  context "For a new contact message" do
    
    it "should send email" do    
      c = FactoryGirl.build(:contact_message)    
      email = c.deliver
      pp email.parts[1].body
    end
    
  end
  
  context "For the free_trial expiration email" do
    before do
      user = FactoryGirl.create(:user)
      @presenter = FreeTrialPresenter.new(user)
    end
    
    it "should contain user's first name" do
      email = PostOffice.free_trial_expiration(@presenter).deliver
      email.parts[0].body.should include 'Dear John,'
    end    
  end
  
  context "For the 1st time invitation email" do
  
    before do
      @invitation = FactoryGirl.build(:invitation)
      url = 'http://host.com/invitations'    
      @presenter = IntroductoryInvitationPresenter.new(@invitation, url)            
    end

    it "should send the invitation email when called" do    
      previous = ActionMailer::Base.deliveries.count
      email = PostOffice.invitation(@presenter).deliver  
      ActionMailer::Base.deliveries.count.should == previous + 1
    end

    it "should send email to the user's email address" do
      email = PostOffice.invitation(@presenter).deliver
      email.to.should == [@invitation.email]
    end
    
    it "should send multipart email" do
      email = PostOffice.invitation(@presenter).deliver
      email.parts.count.should == 2      
    end
    
    it "should contain Adobe link in the TXT version" do      
      email = PostOffice.invitation(@presenter).deliver
      email.parts[0].body.should include('http://get.adobe.com/reader/')
    end
    
    it "Test version should contain the invitation message" do
      email = PostOffice.invitation(@presenter).deliver
      email.parts[0].body.should include @presenter.message            
      
      #pp email.parts[1].body
      
    end
    
  end  
    
end