require 'spec_helper'

describe Picture do
  
  it "should return correct author_id" do            
    c = Factory(:case)
    p = Factory(:picture, :block => Factory(:block, :case => c))    
    p.author_id.should == c.author.id    
  end
  
  it "should return correct file type" do
    p = Factory(:picture)  
    p.file_type.should == 'pictures'
    
  end
  
  context "for the uploaded file picture should" do
  
    before do
      
      @filepath = fixture_file_path('sample_image1.png')
      
      data = {
        :filepath           => @filepath,
        :original_filename  => 'sample_image1.png'
      }
      upload = Uploader.new(data)
      
      block = Factory(:block)       
      filename = Picture.store(block.case.author, upload)    
      @picture = Factory(:picture, :path => filename, :block => block)
      
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