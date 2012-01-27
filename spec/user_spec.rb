require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe User do
  it 'should be valid' do
    FactoryGirl.build(:user).should be_valid
  end

  it "should have link to a picture through blocks and cases" do    
    picture = FactoryGirl.create(:picture)
    user = picture.block.case.user
    user.pictures.should include(picture)
  end
  
  it "should have videos through blocks and cases" do
    video = FactoryGirl.create(:video)
    user = video.block.case.user
    user.videos.should include(video)
  end
end

