require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Footer do
  
  it 'JSON should return proper textAlign' do
    footer = Footer.new(
      :text_align => :left
    )    
    decoded = ActiveSupport::JSON.decode(footer.to_json(:camelize => true))    
    decoded['textAlign'].to_s.should == 'left'            
  end
  
  it 'JSON should contain top divider settings' do
    footer = Footer.new(
      :divider_above  => true,
      :divider_size   => 10,
      :divider_width  => 75,
      :divider_color  => :blue
    )    
    decoded = ActiveSupport::JSON.decode(footer.to_json(:camelize => true))    
    decoded['topDivider']['height'].should == 10
  end
  
  it 'JSON should contain bottom divider settings' do
    footer = Footer.new(
      :divider_below  => true      
    )    
    decoded = ActiveSupport::JSON.decode(footer.to_json(:camelize => true))    
    decoded['bottomDivider']['height'].should == 1
  end
  
end
