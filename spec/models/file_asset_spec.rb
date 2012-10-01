require 'spec_helper'

describe FileAsset do
  
  context "creating a FileAsset" do
  
    before do
      @asset = FileAsset.create(
        :role         => :main,
        :path         => 'something',
        :filesize     => 100,
        :format       => :mpg,
        :content_type => 'image/png'
    )
    end
    
    it 'should set the content_type' do    
      @asset.content_type.should == 'image/png'
    end
    
    it 'should set the role' do    
      @asset.role.to_sym.should == :main
    end
    
    it 'should set the format' do    
      @asset.format.to_sym.should == :mpg
    end
    
    it 'should set the path' do    
      @asset.path.should == 'something'
    end
    
  end    
  
  context "linked with a picture record" do      
  
    before do
      @filepath = fixture_file_path('sample_image1.png')
      data = {
        :filepath           => @filepath,
        :original_filename  => 'sample_image1.png',
        :content_type       => 'image/png'
      }
      upload = Uploader.new(data)
      @picture = FactoryGirl.create(:picture, :uploaded_file => upload)      
      @picture = Picture.find @picture.id
      
      @storage1 = FactoryGirl.create(:storage, :mount_point => 'tmp/mnt/vol1')
    end
    
    it "should store the image under the main asset" do
      File.exists?(@picture.main_file_asset.full_filepath).should be_true
    end
    
    it "should update full filepath to use the storage" do      
      @picture.move_to_storage(@storage1)
      path = @picture.main_file_asset.full_filepath    
      path.start_with?("tmp/mnt/vol1/files/#{@picture.author.id}/pictures").should be_true        
    end
    
    it "should update base_dir to use the storage" do
      @picture.move_to_storage(@storage1)
      path = @picture.base_dir
      path.start_with?("tmp/mnt/vol1/files/#{@picture.author.id}/pictures").should be_true        
    end
    
    it "should not contain the files in the old location" do
      old_dir = @picture.base_dir
      @picture.move_to_storage(@storage1)            
      Dir[old_dir + '/*'].count.should == 0
    end  
    
    it "should contain files in the new location" do                              
      @picture.move_to_storage(@storage1)      
      Dir[@picture.base_dir + '/*'].count.should == 1
    end
    
    it "should have the same full_filepath after moving back" do
      path1 = @picture.main_file_asset.full_filepath
      @picture.move_to_storage(@storage1)
      @picture.move_to_storage(nil)
      path2 = @picture.main_file_asset.full_filepath
      
      path2.should == path1
      
    end
    
    it "should delete files in the new location after moving back" do                              
      @picture.move_to_storage(@storage1)
      new_dir = @picture.base_dir
      @picture.move_to_storage(nil)
      Dir[new_dir + '/*'].count.should == 0
    end
    
    it "should contain files the old location after moving back" do                              
      old_dir = @picture.base_dir
      @picture.move_to_storage(@storage1)
      @picture.move_to_storage(nil)
      Dir[old_dir + '/*'].count.should == 1
    end
    
  end
  
end