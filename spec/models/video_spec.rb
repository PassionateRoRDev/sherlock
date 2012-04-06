require 'spec_helper'

describe Video do
  
#  it "should have proper author_id" do        
#    c = Factory(:case)
#    video = Factory.build(:video, :block => Factory(:block, :case => c))   
#    c.author.id.should == video.author_id           
#    
#  end
#  
#  it 'should store the video contents from a file' do
#    v = Factory.build(:video)
#    filename = 'sample.zip'
#    v.path = filename
#    v.store_from_source(filename, File.new(fixture_file_path(filename)))    
#    Dir[v.base_dir + '/*'].count.should == 1    
#  end
#  
#  it 'should extract thumbnail from a .zip file' do
#    v = Factory.build(:video)
#    filename = 'sample.zip'
#    v.path = v.store_from_source(filename, File.new(fixture_file_path(filename)))    
#    v.extract_thumbnail_from_zip    
#    Dimensions.dimensions(File.new(v.full_thumbnail_path)).should == [465, 349]    
#  end
#  
#  it 'should extract thumbnail from a movie' do
#    v = Factory.build(:video, :thumbnail_pos => '00:00:01')
#    filename = 'video1.mpg'
#    v.path = v.store_from_source(filename, File.new(fixture_file_path(filename)))    
#    v.extract_thumbnail_from_movie
#    Dimensions.dimensions(File.new(v.full_thumbnail_path)).should == [160, 120]
#  end
#  
#  it 'should calculate fps correctly' do
#    v = Factory.build(:video)
#    fps = v.calculate_fps(25, 1000)
#    fps.should == "25.0000"
#  end
#  
#  it 'should calculate fps correctly' do
#    v = Factory.build(:video)
#    fps = v.calculate_fps(250, 10000)
#    fps.should == "25.0000"
#  end
#  
#  context 'when encoding from a zip' do
#    
#    before do     
#      @video = Factory.build(:video, :thumbnail_pos => '00:00:01')
#      filename = 'frames1.zip'
#      @video.path = @video.store_from_source(filename, File.new(fixture_file_path(filename)))
#      @video.capture_start = 0
#      @video.capture_end   = 1000          
#    end
#    
#    it 'should calculate 7 fps from 7 frames for 1 second movie' do
#      @video.encode_from_zip
#      @video.fps.to_f.should be_within(0.01).of(7.0)
#    end   
#    
#    it 'should extract 1st picture as the thumbnail' do
#      @video.encode_from_zip      
#      dims = Dimensions.dimensions(@video.full_thumbnail_path)
#      dims[0].should == 465
#    end
#    
#    it 'should take the width from 1st image' do
#      @video.encode_from_zip
#      @video.width.should == 465
#    end
#    
#    it 'should create a move file' do
#      @video.encode_from_zip
#      @video.full_filepath.end_with?('.mov').should be_true
#    end
#    
#  end
  
  context 'when MPG is uploaded' do
    before do
      filename = 'video1.mpg'   
      data = {
        :filepath           => fixture_file_path(filename),        
        :original_filename  => filename
      }
      upload = Uploader.new(data)
      @video = Factory(:video, 
        :uploaded_file      => upload,
        :thumbnail_pos      => '00:00:01'
      )
    end
    
    it 'should create FLV copy' do      
      Dir[File.join @video.base_dir, '*.flv'].count.should == 1
    end
    
    it 'should extract PNG thumbnail' do      
      Dir[File.join @video.base_dir, '*.png'].count.should == 1
    end
    
    it 'should extract PNG thumbnail with proper dims' do      
      file = Dir[File.join @video.base_dir, '*.png'].first
      Dimensions.dimensions(file).should == [160, 120]
    end
    
    it "should set its own dimensions to thumbnail's" do
      @video.width.should == 160
      @video.height.should == 120
    end
    
  end
    
end
