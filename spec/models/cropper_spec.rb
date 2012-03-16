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
  
  it "Should crop the picture and save result as 100x80 pic" do
    filename = @cropper.crop(@image_path, 10, 10, 100, 80)
    Dimensions.dimensions(filename).should == [100, 80]    
  end
  
  it "Should crop the picture and save result as 100x80 pic with string args" do
    filename = @cropper.crop(@image_path, '10', '10', '100', '80')
    Dimensions.dimensions(filename).should == [100, 80]    
  end
  
end