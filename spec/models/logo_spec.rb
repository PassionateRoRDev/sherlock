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
  
  context "for the uploaded file picture should" do    
    
    before do    
      filename = 'shelockdocslogo.jpg'
      user = Factory(:user)
      @filepath = fixture_file_path(filename)      
      data = {
        :filepath           => @filepath,
        :original_filename  => filename
      }
      upload = Uploader.new(data)      
      filename = Logo.store(user, upload)    
      @logo = Factory(:logo, 
        :user => user, 
        :path => filename, 
        :content_type => 'image/jpeg')
    
    end
    
    it "store the image in the original dimensions" do
      original = Dimensions.dimensions(@filepath)
      Dimensions.dimensions(@logo.full_filepath).should == original            
    end
    
  end
  
end
  