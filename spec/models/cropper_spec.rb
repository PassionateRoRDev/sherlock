require 'spec_helper'

describe Cropper do
    
  before do
    prepare_files_dir
    @image_path = copy_fixture_file('sample_image1.png')    
    @cropper = Cropper.new    
  end
    
  it "Should crop the picture and save a result" do
    expected_filename = @image_path + '.cropped'
    @cropper.crop(@image_path, 10, 10, 100, 100).should == expected_filename
  end
  
  it "Should return nil if width is 0" do    
    @cropper.crop(@image_path, 10, 10, 0, 100).should == nil    
  end
  
  it "Should return nil if height is 0" do    
    @cropper.crop(@image_path, 10, 10, 100, 0).should == nil    
  end
  
  it "Should crop the picture and save result as 100x80 pic" do
    filename = @cropper.crop(@image_path, 10, 10, 100, 80)
    Dimensions.dimensions(filename).should == [100, 80]    
  end
  
  it "Should not crop the picture if width is 0" do
    expected_filename = @image_path + '.cropped'
    @cropper.crop(@image_path, 10, 10, 0, 100)
    File.exists?(expected_filename).should be_false
  end
  
  it "Should crop the picture and save result as 100x80 pic with string args" do
    filename = @cropper.crop(@image_path, '10', '10', '100', '80')
    Dimensions.dimensions(filename).should == [100, 80]    
  end
  
end