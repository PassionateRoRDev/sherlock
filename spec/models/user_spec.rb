require 'spec_helper'

describe User do
  it 'should be valid' do
    FactoryGirl.build(:user).should be_valid
  end

  it "should have link to a picture through blocks and cases" do    
    filename = 'sample_image1.bmp'   
    data = {
      :filepath           => fixture_file_path(filename),
      :original_filename  => filename
    }
    uploaded = Uploader.new(data)    
    picture = FactoryGirl.create(:picture, :uploaded_file => uploaded)
    author = picture.block.case.author
    author.pictures.should include(picture)
  end
  
#  it "should have videos through blocks and cases" do
#    block = Factory(:block)
#    video = Factory.build(:video, :block => block)
#    author = block.case.author
#    author.videos.should include(video)
#  end

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
  
  it 'should have 0 clients initially' do
    investigator = Factory(:user)
    investigator.clients.should == []    
  end
  
  it 'should have 1 client added when asked to do so twice' do
    investigator = Factory(:user)
    client = Factory(:user, :email => 'client1@aol.com')
    investigator.add_client(client)
    investigator.add_client(client)
    investigator.clients.count.should == 1
  end
  
  it 'should return email as full name if first name and last name are blank' do
    user = Factory(:user, 
      :first_name => nil, 
      :last_name => nil, 
      :email => 'user@mail.com'
    )
    user.full_name.should == "user@mail.com"
  end
  
  it 'should return last name as full name if first name is blank' do
    user = Factory(:user, 
      :first_name => nil, 
      :last_name => 'Smith', 
      :email => 'user@mail.com'
    )
    user.full_name.should == "Smith"
  end
  
  it 'without the cases, should have 0 space usage reported' do
    user = Factory(:user)
    user.space_usage.should == 0
  end
  
  it 'should have empty space usage if has a case but without file assets' do
    c = Factory(:case)
    c.author.space_usage.should == 0
  end
  
  it 'should have usage equal to the stored picture for one case with 1 pic' do
    
    filename = 'sample_image1.bmp'
    picture_path = fixture_file_path(filename)    
    block = Factory(:block)    
    data = {
      :filepath           => picture_path,
      :original_filename  => filename
    }
    uploaded = Uploader.new(data)    
    picture = Factory(:picture, :block => block, :uploaded_file => uploaded)    
    
    current_size = File.size(picture.full_filepath)
    
    #block.case.author.space_usage.should == current_size + File.size(picture_path)
    
  end
  
end

