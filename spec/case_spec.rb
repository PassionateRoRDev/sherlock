require 'spec_helper'

describe Case do
  it 'is valid' do
    FactoryGirl.build(:case).should be_valid
  end

end

