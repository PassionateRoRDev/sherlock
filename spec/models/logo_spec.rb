require 'spec_helper'

describe Logo do
  
  it 'Should return a correct author_id' do    
    user = Factory(:user)
    logo = Factory.build(:logo, :user => user)    
    logo.author_id.should == user.id
  end
  
  it 'Should not break on invalid dimensions when height_for_display is called' do
    logo = Factory.build(:logo)
    max_height = 200
    logo.height_for_display(max_height).should == max_height  
  end
  
end
  