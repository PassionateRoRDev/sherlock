require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Letterhead do
  
  it 'Should return a correct author_id' do
    user = User.new() { |u| u.id = 1}
    logo = Logo.new(
      :user => user
    )
    logo.author_id.should == user.id
  end
  
end
  