require 'spec_helper'

describe Picture do
  
  it "should classify an image as an image" do
    f = File.open(fixture_file_path('sample_image1.png'))
    Picture.new.is_image?(f.read).should be_true
  end
  
  it "should generate a unique filename, removing the leading hash if present" do
    p = FactoryGirl.build(:picture)
    new_name = p.generate_new_filename 'original.png'
    new_name2 = p.generate_new_filename new_name        
    new_name2.length.should == new_name.length
  end
  
  it "should require a file upload for a new object" do
    picture = FactoryGirl.build(:picture)    
    picture.valid?.should be_false
    picture.errors[:uploaded_file].should_not be_empty    
  end
  
  it "should be invalid for uploaded_file set to text file" do
    user = FactoryGirl.create(:user)
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
    Picture.new.is_image?(f.read).should_not be_true
  end
  
  it "should classify a pdf file as an image" do
    f = File.open(fixture_file_path('sample.pdf'))
    Picture.new.is_image?(f.read).should be_true
  end
  
            
  it "should return correct author" do
    c = FactoryGirl.create(:case)
    p = FactoryGirl.build(:picture, :block => FactoryGirl.create(:block, :case => c))
    p.author.should == c.author
  end

  it "should return correct author_id" do            
    c = FactoryGirl.create(:case)
    p = FactoryGirl.build(:picture, :block => FactoryGirl.create(:block, :case => c))
    p.author_id.should == c.author.id    
  end

  it "should return correct file type" do
    p = FactoryGirl.build(:picture)  
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
        
  end
  
  context "for uploaded BMP file" do
    
    before do
      filename = 'sample_image1.bmp'
      @original_file_path = fixture_file_path(filename)
      data = {
        :filepath           => @original_file_path,
        :content_type       => 'image/bmp',
        :original_filename  => filename        
      }
      @upload = Uploader.new(data)
      @picture = Picture.new(:title => 'Test picture', :uploaded_file  => @upload)
      @picture.block = FactoryGirl.create(:block)
      @picture.save
      @picture.reload
    end
    
    it "should save the image with PNG suffix" do            
      @picture.path.end_with?('sample_image1.png').should be_true            
    end
    
    it "should save orig file_asset with original content type" do
      @picture.orig_file_asset.content_type.should == 'image/bmp'
    end
    
    it "should calculate the total space usage properly" do            
      @picture.usage.should == @picture.main_file_asset.filesize + @picture.orig_file_asset.filesize            
    end
    
    it "should save the copy with .orig suffix" do
      @picture.orig_path.should_not be_empty
      File.exists?(@picture.orig_path).should be_true      
      File.new(@picture.orig_path).size.should == File.new(@original_file_path).size      
    end
    
    it "should return correct dimensions for the file" do
      @picture.dimensions.should == [465, 349]
    end
    
    it "should store correct dimensions in the record" do
      [@picture.width, @picture.height].should == [465, 349]
    end
    
    it "should have image/png content_type after conversion" do
      @picture.content_type.should == 'image/png'
    end
    
  end  

  context "for the uploaded file should" do
  
    before do      
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
    
    it "return correct dimensions" do
      @picture.dimensions.should == [465, 349]
    end
    
    it "should create one file_asset record" do      
      @picture.file_assets.count.should == 1
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
    
    it "should crop and update its own dimensions" do
      @picture.crop [10, 10, 100, 50]
      [@picture.width, @picture.height].should == [100, 50]
    end
    
    it "should crop and update the main file_asset size" do
      @picture.crop [10, 10, 100, 50]      
      @picture.main_file_asset.filesize.should == File.size(@picture.full_filepath)
    end
    
    it "should crop and return true if args are strings" do
      @picture.crop(['10', '10', '100', '50']).should be_true      
    end
    
    it "should crop and not produce any additional files" do
      @picture.crop([10, 10, 100, 50])      
      # there should be 2 files under pictures right now: picture and backup      
      Dir[@picture.base_dir + '/*'].count.should == 2
    end
    
    it "should not crop if width is 0" do
      @picture.crop([10, 10, 0, 50]).should be_false      
    end
    
    it "should save a backup before cropping" do
      @picture.crop([10, 10, 100, 50])
      File.new(@picture.backup_path).size.should == File.size(@filepath)
    end
    
    it "should have two file_assets after the crop (2nd being for the backup)" do
      @picture.crop([10, 10, 100, 50])
      @picture.file_assets.count.should == 2
    end
    
    it "backup file_asset should store the original filesize" do
      @picture.crop([10, 10, 100, 50])
      @picture.backup_file_asset.filesize.should == File.size(@filepath)
    end
    
    it "backup file_asset should store the original content-type" do
      @picture.crop([10, 10, 100, 50])
      @picture.backup_file_asset.content_type.should == 'image/png'
    end
    
    it "should be able to restore itself from a backup" do
      @picture.crop([10, 10, 100, 50])
      @picture.restore_from_backup
      File.new(@picture.full_filepath).size.should == File.new(@filepath).size      
    end
    
    it "should have 1 file_asset after restoring from backup" do
      @picture.crop([10, 10, 100, 50])
      @picture.restore_from_backup
      @picture.file_assets.count.should == 1
    end
    
    it "should update dimensions if restored from backup" do
      @picture.crop([10, 10, 100, 50])
      @picture.restore_from_backup
      [@picture.width, @picture.height].should == [465, 349]
    end
    
    it "should remove its file when it gets deleted" do
      @picture.destroy
      File.exists?(@picture.full_filepath).should be_false
    end
    
    it "should remove its file_asset record when it gets deleted" do
      @picture.destroy      
      FileAsset.find_all_by_parent_id(@picture.id).count.should == 0
    end
    
    it "should remove its backup file when it gets deleted" do
      @picture.backup
      backup_file = @picture.backup_path
      @picture.destroy
      File.exists?(backup_file).should be_false
    end    
  
    context "when a new picture is uploaded" do
        
      before do      
        @filepath_new = fixture_file_path('sample_logo1.png')
        data = {
          :filepath           => @filepath_new,
          :original_filename  => 'sample_logo1.png'
        }
        upload = Uploader.new(data)                  
        
        @picture.uploaded_file = upload  
        @picture.save
      
        # reload the pic from the db:
        @picture = Picture.find @picture.id      
        
      end      
    
      it "should update the picture when a new one is uploaded" do
        File.size(@picture.full_filepath).should == File.size(@filepath_new)
      end

      it "should update dims when a new picture is uploaded" do
        [@picture.width, @picture.height].should == Dimensions.dimensions(@filepath_new)
      end        
    
    end
    
  end
  
  
end
