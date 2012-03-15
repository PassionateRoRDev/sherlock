require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PostOffice do
  
  context "For the 1st time invitation email" do
  
    before do 
      @invitation = Invitation.new(
        :email    => 'user1@mail.com',
        :name     => 'John Smith',
        :message  => 'Hey John, take a look at these pics',
        :case_id  => 1
      )    
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
      
      pp email.parts[1].body
      
    end
    
  end  
    
end