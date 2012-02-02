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
      PostOffice.should_not_receive(:report)
      Factory.build(:invitation, :email => nil).deliver
    end
  end

  describe 'target' do
    it 'is formatted for use in email' do
      n = Factory.build(:invitation, :name => 'Bill Harris', :email => 'bill@tw.com').target.should == "Bill Harris <bill@tw.com>"
    end
  end

#  it 'creates an invitation if user does not already exist' do
#    User.should_receive(:invite!).with(:email => 'new_user@email.com').and_return(nil)
#    Factory.build(:invitation, :email => 'new_user@email.com').deliver
#  end
end


