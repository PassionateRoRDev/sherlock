require 'spec_helper'

describe Video do
  
  it "should have proper author_id" do    
    c = Factory(:case)
    video = Factory(:video, :block => Factory(:block, :case => c))   
    c.author.id.should == video.author_id           
    
  end
    
end
