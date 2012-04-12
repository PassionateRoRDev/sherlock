require 'spec_helper'

describe Letterhead do
    
  it 'should always return alignment as center' do
    letterhead = Factory(:letterhead, :alignment => 'left')
    letterhead.alignment.should == 'center'
  end
  
  it 'JSON should not return created_at if its excluded' do
    letterhead = Factory(:letterhead)
    options = {
      :except => [:created_at]      
    }    
    decoded = ActiveSupport::JSON.decode(letterhead.to_json(options))
    decoded.should_not have_key('created_at')
  end
  
  it 'JSON should return proper textAlign' do
    letterhead = Factory(:letterhead, :text_align => :left)
    decoded = ActiveSupport::JSON.decode(letterhead.to_json(:camelize => true))    
    decoded['textAlign'].to_s.should == 'left'            
  end
  
  it 'JSON should contain divider settings' do
    letterhead = Factory(:letterhead, 
      :divider_above  => true,
      :divider_size   => 10,
      :divider_width  => 75,
      :divider_color  => :blue
    )    
    decoded = ActiveSupport::JSON.decode(letterhead.to_json(:camelize => true))    
    decoded['divider']['height'].should == 10
  end
  
  it 'JSON should return :contents as :text' do
    letterhead = Factory(:letterhead, :contents => 'This is my letterhead')    
    decoded = ActiveSupport::JSON.decode(letterhead.to_json(:camelize => true))    
    decoded['text'].should == 'This is my letterhead'
  end
  
  it 'JSON should return logo if one has been set' do
    letterhead = Factory.build(:letterhead,
      :logo           => Factory.build(:logo),
      :logo_alignment => :right
    )
    
    options = { :camelize => true, :include => [:logo] }
    
    decoded = ActiveSupport::JSON.decode(letterhead.to_json(options))    
    decoded['logo']['path'].should == 'logo.png'
    decoded['logo']['align'].should == 'right'
  end
  
  it 'JSON should return alignment = center no matter what' do
    letterhead = Factory(:letterhead, :alignment => 'left')
    decoded = ActiveSupport::JSON.decode letterhead.to_json
    decoded['alignment'].should == 'center'
  end
  
end
