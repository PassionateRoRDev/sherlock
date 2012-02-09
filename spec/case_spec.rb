require 'spec_helper'

describe Case do
  it 'is valid' do
    FactoryGirl.build(:case).should be_valid
  end

  it 'adds the author to the list of viewers on create' do
    bob = FactoryGirl.create(:user)
    info = FactoryGirl.create(:case, :author => bob)
    info.viewers.should include(bob)
  end

end

