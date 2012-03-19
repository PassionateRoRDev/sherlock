require 'spec_helper'

describe Case do
  
  it 'is valid' do
    FactoryGirl.build(:case).should be_valid
  end
  
  context "Existing case" do 
  
    before do
      @case = Factory(:case)
    end
    
    it 'should have 0 blocks initially' do
      @case.blocks.should be_empty
    end
    
    it 'should have 0 pictures initially' do
      @case.pictures.should be_empty
    end
  
    context 'when copying an existing picture' do

      before do
      
        @filepath = fixture_file_path('sample_image1.png')

        data = {
          :filepath           => @filepath,
          :original_filename  => 'sample_image1.png'
        }
        upload = Uploader.new(data)

        block = Factory(:block, :case => @case)       
        filename = Picture.store(block.case.author, upload)    
        
        @picture = Factory(:picture, 
          :path               => filename, 
          :block              => block,          
          :content_type       => 'image/png',
          :original_filename  => data[:original_filename])
        
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
      
      it 'should create 1 new picture file for this author' do
        picture_copy = @case.create_block_from_picture(@picture, @crop_params)
        dir = FileAsset::dir_for_author(@picture.author_id, 'pictures')
        Dir[dir + '/*'].count.should == 2
      end
      
      it 'cropped copy should not have a backup' do
        picture_copy = @case.create_block_from_picture(@picture, @crop_params)
        File.exists?(picture_copy.backup_path).should be_false
      end
                  
    end
    
  end

end

