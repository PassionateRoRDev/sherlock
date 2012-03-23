require 'spec_helper'

describe Invitation do

  it 'is valid' do    
    somebody = Factory.build(:user, :email => 'somebody@else.com')
    Factory.build(:invitation, :current_user => somebody).should be_valid
  end

  it 'loads the associated case' do
    Case.should_receive(:find).with(2)
    Invitation.new(:case_id => 2).case
  end

  describe 'deliver' do
    it 'does not send mail if invalid' do
      PostOffice.should_not_receive(:invitation)
      Factory.build(:invitation, :email => nil).deliver
    end

    it 'sends an invitation if valid' do
      somebody = Factory.build(:user, :email => 'somebody@else.com')
      i = mock(PostOffice)
      i.should_receive(:deliver)
      PostOffice.should_receive(:invitation).and_return(i)
      Factory.build(:invitation, :current_user => somebody).deliver
    end
    
    it 'sends an invitation if the same client is invited to 2nd case' do
      
      somebody = Factory(:user, :email => 'somebody@else.com')
      
      kase1 = Factory(:case, :author => somebody)
      kase2 = Factory(:case, :author => somebody)
      
      i = mock(PostOffice)
      i.should_receive(:deliver)
      PostOffice.should_receive(:invitation).and_return(i)
      
      Factory.build(:invitation, 
        :current_user => somebody, 
        :case_id => kase1.id,
        :email    => 'client@aol.com'
      ).deliver
      
      i = mock(PostOffice)
      i.should_receive(:deliver)
      PostOffice.should_receive(:invitation).and_return(i)
      
      Factory.build(:invitation, 
        :current_user => somebody, 
        :case_id => kase2.id,
        :email    => 'client@aol.com'
      ).deliver                  
      
    end
    
  end

  it 'adds permission for the new user to view the case' do
    somebody = Factory.build(:user, :email => 'somebody@else.com')
    n = Factory.build(:invitation, :current_user => somebody)
    n.deliver
    client = User.where(:email => n.email ).first
    c = Case.find( n.case )
    client.can_view?( c ).should be_true
  end

  it 'adds the invited user as a new client' do
    somebody = Factory(:user, :email => 'somebody@else.com')
    kase = Factory(:case, :author => somebody)
    n = Factory.build(:invitation, :current_user => somebody, :case_id => kase.id)
    n.deliver    
    client = User.find_by_email(n.email)        
    somebody.clients.include?(client).should be_true    
  end
  
end


