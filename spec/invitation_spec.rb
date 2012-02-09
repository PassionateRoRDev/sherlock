require 'spec_helper'

describe Invitation do

  it 'is valid' do
    Factory.build(:invitation).should be_valid
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
      i = mock(PostOffice)
      i.should_receive(:deliver)
      PostOffice.should_receive(:invitation).and_return(i)
      Factory.build(:invitation).deliver
    end
  end

  it 'adds permission for the new user to view the case' do
    n = Factory.build :invitation
    n.deliver
    client = User.where(:email => n.email ).first
    c = Case.find( n.case )
    client.can_view?( c ).should be_true
  end

end


