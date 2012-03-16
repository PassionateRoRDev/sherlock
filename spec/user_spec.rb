require 'spec_helper'

describe User do
  it 'should be valid' do
    FactoryGirl.build(:user).should be_valid
  end

  it "should have link to a picture through blocks and cases" do    
    picture = FactoryGirl.create(:picture)
    author = picture.block.case.author
    author.pictures.should include(picture)
  end
  
  it "should have videos through blocks and cases" do
    video = FactoryGirl.create(:video)
    author = video.block.case.author
    author.videos.should include(video)
  end

  it 'can not view cases by default' do
    secret = Factory.create(:case)
    snoop = Factory.create(:user)
    snoop.can_view?( secret ).should == false
  end

  it 'can view cases when it is on the viewer list' do
    client = Factory.create(:user)
    info = Factory.create(:case, :viewers => [client])
    
    client.can_view?( info ).should == true
  end

  it 'can view cases when listed as the author' do
    author = Factory.create(:user)
    great_am_tale = Factory.create(:case, :author => author)

    author.can_view?( great_am_tale ).should == true
  end

  it 'will not see duplicate cases when a viewer and an author.' do
    author = Factory.create(:user)
    casework = Factory.create(:case, :author => author, :viewers => [author])
    casework.reload.viewers.should include author
    author.reload.should have(1).cases
  end
  it 'has a list of authored cases' do
    c = Factory.create(:case)
    c.author.authored_cases.should include(c)
  end
end

