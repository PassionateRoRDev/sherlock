require 'spec_helper'

describe Case do
  
  it 'is valid' do
    FactoryGirl.build(:case).should be_valid
  end
  
  context 'creating a new static case' do
    
    context 'without uploaded file' do
      before do
        @c = Case.new(
          :title => 'Title', 
          :summary => 'Summary', 
          :is_static => true)
        @c.author = FactoryGirl.create(:user)
      end
      
      it 'should not be valid' do
        @c.valid?.should be_false
      end      
    end
    
    context 'with uploaded file' do
      
      before do
        @c = Case.new(
          :title => 'Title', 
          :summary => 'Summary', 
          :is_static => true
        )
        
        filename = 'sample.pdf'   
        data = {
          :filepath           => fixture_file_path(filename),
          :content_type       => 'application/pdf',
          :original_filename  => filename
        }
        
        uploaded = Uploader.new(data)      
        
        @c.document = Document.new(
          :title => 'Sample1', 
          :uploaded_file  => uploaded
        )
        @c.author = FactoryGirl.create(:user)
        
      end
      
      it 'should be valid' do
        @c.valid?.should be_true
      end
      
      it 'should work' do
        @c.save
        @c.reload.is_static.should be_true
      end
      
    end
    
  end    
  
  context "Existing case" do 
  
    before do
      @case = FactoryGirl.create(:case)
    end
    
    it 'should have 0 blocks initially' do
      @case.blocks.should be_empty
    end
    
    it 'should have 0 pictures initially' do
      @case.pictures.should be_empty
    end
  
    context 'when swapping 2 blocks' do      
      before do      
        FactoryGirl.create(:block, 
          :case => @case,
          :html_detail => FactoryGirl.create(:html_detail))    

        FactoryGirl.create(:block, 
          :case => @case,
          :html_detail => FactoryGirl.create(:html_detail))    
        
      end
      
      it "first block should have weight 1" do        
        @case.blocks.first.weight.should == 1
      end
      
      it "second block should have weight 2" do        
        @case.blocks.last.weight.should == 2
      end
      
      it "first block should have weight 2 after the swap" do        
        block1 = @case.blocks.first
        block2 = @case.blocks.last
        @case.swap_blocks block1, block2
        @case.blocks.find_by_id(block1.id).weight.should == 2
      end
      
      it "second block should have weight 1 after the swap" do
        block1 = @case.blocks.first
        block2 = @case.blocks.last
        @case.swap_blocks block1, block2
        @case.blocks.find_by_id(block2.id).weight.should == 1
      end      
    
    end
    
    context 'when copying an existing picture' do

      before do      
        @filepath = fixture_file_path('sample_image1.png')
        data = {
          :filepath           => @filepath,
          :content_type       => 'image/png',
          :original_filename  => 'sample_image1.png'
        }
        upload = Uploader.new(data)            
        block = FactoryGirl.create(:block, :case => @case)
        @picture = FactoryGirl.create(:picture, :block => block, :uploaded_file => upload)        
        @crop_params = [10, 10, 100, 50]
      end

      it 'picture copy should have the same content type' do
        picture_copy = @case.copy_picture(@picture)        
        picture_copy.content_type.should == @picture.content_type
      end
      
      it 'picture copy should have the same size as the original' do                
        picture_copy = @case.copy_picture(@picture)                        
        file1 = File.new(@picture.full_filepath)
        file2 = File.new(picture_copy.full_filepath)        
        file1.size.should == file2.size                
      end
      
      it 'picture copy should have a different path as the original' do
        picture_copy = @case.copy_picture(@picture)
        @picture.full_filepath.should_not == picture_copy.full_filepath
      end
      
      it 'picture copy should have a derived title' do
        picture_copy = @case.copy_picture(@picture)
        picture_copy.title.should == "Copy of " + @picture.title
      end
      
      it 'picture copy should have a unique code assigned' do
        picture_copy = @case.copy_picture(@picture)
        picture_copy.unique_code.should_not be_empty
      end
      
      it 'picture copy should have a different unique code than the original' do
        picture_copy = @case.copy_picture(@picture)
        picture_copy.unique_code.should_not == @picture.unique_code
      end
            
      it 'should create 1 new block' do              
        @case.copy_picture(@picture)        
        @case.blocks.count.should == 2
      end
      
      it 'cropped copy should be smaller than the original' do
        picture_copy = @case.create_block_from_picture(@picture, @crop_params)
        file1 = File.new(@picture.full_filepath)
        file2 = File.new(picture_copy.full_filepath)        
        file2.size.should < file1.size
      end
      
      it 'cropped copy should return correct dimensions' do
        picture_copy = @case.create_block_from_picture(@picture, @crop_params)
        picture_copy.dimensions.should == @crop_params[2, 3]
      end
      
      it 'cropped copy should store correct dimensions' do
        picture_copy = @case.create_block_from_picture(@picture, @crop_params)
        [picture_copy.width, picture_copy.height].should == @crop_params[2, 3]
      end
      
      it 'should create 1 new picture file for this author' do
        picture_copy = @case.create_block_from_picture(@picture, @crop_params)
        Dir[File.join @picture.base_dir, '*'].count.should == 2
      end
      
      it 'cropped copy should not have a backup' do
        picture_copy = @case.create_block_from_picture(@picture, @crop_params)
        File.exists?(picture_copy.backup_path).should be_false
      end
                  
    end
    
  end

end

