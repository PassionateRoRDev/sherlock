require 'spec_helper'

describe Block do
  
  it "1st block should have weight = 1 assigned when added to a case" do    
    block1 = Factory(:block)
    block1.weight.should == 1    
  end  
  
  it "2nd block should have weight = 2 assigned when added to a case" do
    kase = Factory(:case)
    block1 = Factory(:block, :case => kase)
    block2 = Factory(:block, :case => kase)
    block2.weight.should == 2
  end  
  
  it "2nd block's prev should point to the 1st block" do
    kase = Factory(:case)
    block1 = Factory(:block, :case => kase)
    block2 = Factory(:block, :case => kase)
    block2.prev.should == block1
  end  
  
  it "1st block's prev should point to nil" do
    block1 = Factory(:block)    
    block1.prev.should == nil
  end  
  
  it "Should return alignment of the picture as the block's alignment" do    
    block = Factory(:block)
    Factory(:picture, :block => block, :alignment => 'right')
    block.alignment.should == 'right'
  end
  
  it "Should return alignment of the video as the block's alignment" do
    block = Factory(:block)
    Factory(:video, :block => block, :alignment => 'left')    
    block.alignment.should == 'left'
  end
  
end