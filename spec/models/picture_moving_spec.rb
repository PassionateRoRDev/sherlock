require 'spec_helper'

describe Picture do
  
  context "for uploaded PNG file should" do
  
    before do
      
      @storage1 = FactoryGirl.create(:storage, :mount_point => 'tmp/mnt/vol1')
      
      @filepath = fixture_file_path('sample_image1.png')
      data = {
        :filepath           => @filepath,
        :original_filename  => 'sample_image1.png',
        :content_type       => 'image/png'
      }
      upload = Uploader.new(data)                  
      @picture       = Picture.new(:title => 'New picture', :uploaded_file => upload)      
      @picture.block = FactoryGirl.create(:block)
      @picture.save
      
      # reload the pic from the db:
      @picture = Picture.find @picture.id      
    end
    
    it "should initially be stored in the default storage" do
      @picture.storage.should == nil
    end
    
    it "should update the storage field" do
      @picture.move_to_storage(@storage1)
      @picture.storage.should == @storage1
    end
    
  end
  
end
