# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe User do
  before(:each) do
    @user = User.new
    
  end

  it "should have link to a picture through blocks and cases" do    
    
    @user.email = 'user1@mail.com'
    @user.password = 'password'
    
    @case = Case.new(:title => 'Case 1')
    @user.cases << @case
    @user.save!
    
    @block = Block.new
    @user.cases.first.blocks << @block
    @block.save!
    
    @picture = Picture.new
    @picture.block = @block
    @picture.path = '/tmp/dummy.txt'
    @picture.save!
    
    @user.pictures.should include(@picture)
    
  end
  
  it "should have videos through blocks and cases" do
    
    @user.email = 'user1@mail.com'
    @user.password = 'password'
    
    @case = Case.new(:title => 'Case 1')
    @user.cases << @case
    @user.save!
    
    @block = Block.new
    @user.cases.first.blocks << @block
    @block.save!
    
    @video = Video.new
    @video.block = @block
    @video.path = '/tmp/dummy.avi'
    @video.save!
    
    @user.videos.should include(@video)
    
  end
end

