require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Video do  
  it "should have proper author_id" do        
    u = User.new { |u| u.id = 1}
    c = Case.new(:title => 'Case #170', :summary => 'Summary!', :author => u)    
    video = Video.new(
      :title => 'Video', 
      :path => 'video1.mpg',
      :block  => Block.new(:video => video, :case => c))    
    
    u.id.should == video.author_id           
    
  end
    
end
