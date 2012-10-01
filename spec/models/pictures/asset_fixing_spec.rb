require 'spec_helper'

describe Picture do
  
  context "fixing the broken main asset" do
    before do
      filename = 'sample_image1.png'
      upload = Uploader.new(
        :filepath           => fixture_file_path(filename),        
        :content_type       => 'image/png',
        :original_filename  => filename
      )
      @picture = FactoryGirl.create(:picture, 
        :title => 'Test picture', :uploaded_file  => upload)

      @asset = @picture.main_file_asset    
      @asset.path = nil
      @asset.content_type = nil
      @asset.filesize = nil
      @asset.save
    end
    
    it "should restore the path" do    
      @picture.fix_main_file_asset    
      FileAsset.find(@asset.id).path.should == @picture.path
    end
    
    it "should restore the content type" do    
      @picture.fix_main_file_asset    
      FileAsset.find(@asset.id).content_type.should == @picture.content_type
    end
    
    it "should calculate the file size" do
      @picture.fix_main_file_asset    
      FileAsset.find(@asset.id).filesize.to_i.should_not == 0
    end
    
  end
    
  
end