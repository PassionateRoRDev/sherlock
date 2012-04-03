require 'spec_helper'

describe Picture do
  
  it "should classify an image as an image" do
    f = File.open(fixture_file_path('sample_image1.png'))
    Picture.is_image?(f.read).should be_true
  end
  
  it "should require a file upload for a new object" do
    picture = Factory.build(:picture)    
    picture.valid?.should be_false
    picture.errors[:uploaded_file].should_not be_empty    
  end
  
  it "should be invalid for uploaded_file set to text file" do
    user = Factory(:user)
    filename = 'text_file1.txt'   
    data = {
      :filepath           => fixture_file_path(filename),
      :original_filename  => filename
    }
    uploaded = Uploader.new(data)
    p = Picture.new(:title => 'Test picture', :uploaded_file => uploaded)
    p.valid?.should be_false
    p.errors[:image_type].should_not be_empty
  end
  
  it "should be valid for uploaded PNG file" do
    filename = 'sample_image1.png'   
    data = {
      :filepath           => fixture_file_path(filename),
      :original_filename  => filename
    }
    uploaded = Uploader.new(data)
    p = Picture.new(:title => 'Test picture', :uploaded_file => uploaded)
    p.valid?.should be_true
    p.errors[:image_type].should be_empty
  end
  
  it "should be valid for uploaded BMP file" do    
    filename = 'sample_image1.bmp'   
    data = {
      :filepath           => fixture_file_path(filename),
      :original_filename  => filename
    }
    uploaded = Uploader.new(data)
    p = Picture.new(:title => 'Test picture', :uploaded_file => uploaded)
    p.valid?.should be_true
    p.errors[:image_type].should be_empty
  end
  
  it "should classify a text file as a non-image" do
    f = File.open(fixture_file_path('text_file1.txt'))
    Picture.is_image?(f.read).should_not be_true
  end
  
  it "should classify a pdf file as an image" do
    f = File.open(fixture_file_path('sample.pdf'))
    Picture.is_image?(f.read).should be_true
  end
  
            
  it "should return correct author" do
    c = Factory(:case)
    p = Factory.build(:picture, :block => Factory(:block, :case => c))
    p.author.should == c.author
  end

  it "should return correct author_id" do            
    c = Factory(:case)
    p = Factory.build(:picture, :block => Factory(:block, :case => c))
    p.author_id.should == c.author.id    
  end

  it "should return correct file type" do
    p = Factory.build(:picture)  
    p.file_type.should == 'pictures'    
  end    
  
  context "for a non-image file the upload" do
    
    before do
      filename = 'text_file1.txt'      
      data = {
        :filepath           => fixture_file_path(filename),
        :original_filename  => filename
      }
      @upload = Uploader.new(data)
    end
    
    it "should fail" do
      block = Factory(:block)       
      filename = Picture.store(block.case.author, @upload)    
      filename.should == nil
    end    
  end
  
  context "for uploaded BMP file" do
    
    before do
      filename = 'sample_image1.bmp'
      @original_file_path = fixture_file_path(filename)
      data = {
        :filepath           => @original_file_path,
        :original_filename  => filename        
      }
      @upload = Uploader.new(data)
      @picture = Picture.new(:title => 'Test picture', :uploaded_file  => @upload)
      @picture.block = Factory(:block)
      @picture.save
    end
    
    it "should save the image with PNG suffix" do            
      @picture.path.end_with?('sample_image1.png').should be_true            
    end
    
    it "should save the copy with .orig suffix" do
      @picture.orig_path.should_not be_empty
      File.exists?(@picture.orig_path).should be_true      
      File.new(@picture.orig_path).size.should == File.new(@original_file_path).size      
    end
    
    it "should return correct dimenions for the file" do
      @picture.dimensions.should == [465, 349]
    end
    
  end  

  context "for the uploaded file picture should" do
  
    before do      
      @filepath = fixture_file_path('sample_image1.png')      
      data = {
        :filepath           => @filepath,
        :original_filename  => 'sample_image1.png'
      }
      upload = Uploader.new(data)                  
      @picture       = Picture.new(:title => 'New picture', :uploaded_file => upload)      
      @picture.block = Factory(:block)
      @picture.save
    end
    
    it "return correct dimensions" do
      @picture.dimensions.should == [465, 349]
    end
    
    it "store the uploaded file in a proper location" do      
      File.new(@picture.full_filepath).size.should == File.new(@filepath).size      
    end  

    it "should be able to crop its file" do
      @picture.crop([10, 10, 100, 50])
      Dimensions.dimensions(@picture.full_filepath).should == [100, 50]
    end
    
    it "should crop itself to a smaller file" do
      @picture.crop([10, 10, 100, 50])
      File.new(@picture.full_filepath).size.should < File.new(@filepath).size
    end
    
    it "should crop and return true" do
      @picture.crop([10, 10, 100, 50]).should be_true      
    end
    
    it "should crop and return true if args are strings" do
      @picture.crop(['10', '10', '100', '50']).should be_true      
    end
    
    it "should crop not produce any additional files" do
      @picture.crop([10, 10, 100, 50])      
      # there should be 2 files under pictures right now: picture and backup      
      dir = FileAsset::dir_for_author(@picture.author_id, 'pictures')
      Dir[dir + '/*'].count.should == 2
    end
    
    it "should not crop if width is 0" do
      @picture.crop([10, 10, 0, 50]).should be_false      
    end
    
    it "should save a backup before cropping" do
      @picture.crop([10, 10, 100, 50])
      File.new(@picture.backup_path).size.should == File.new(@filepath).size      
    end
    
    it "should be able to restore itself from a backup" do
      @picture.crop([10, 10, 100, 50])
      @picture.restore_from_backup
      File.new(@picture.full_filepath).size.should == File.new(@filepath).size      
    end
    
    it "should remove its file when it gets deleted" do
      @picture.destroy
      File.exists?(@picture.full_filepath).should be_false
    end    
    
    it "should remove its backup file when it gets deleted" do
      @picture.backup
      backup_file = @picture.backup_path
      @picture.destroy
      File.exists?(backup_file).should be_false
    end    
  
  end
  
  
end
