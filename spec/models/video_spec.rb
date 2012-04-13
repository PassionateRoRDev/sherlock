require 'spec_helper'

describe Video do
  
  it "should have proper author_id" do        
    c = Factory(:case)
    video = Factory.build(:video, :block => Factory(:block, :case => c))   
    c.author.id.should == video.author_id    
  end
  
  it 'should store the video contents from a file' do
    v = Factory.build(:video)
    filename = 'sample.zip'
    v.path = filename
    v.store_from_source(filename, File.new(fixture_file_path(filename)))    
    Dir[v.base_dir + '/*'].count.should == 1    
  end
  
  it 'should extract thumbnail from a .zip file' do
    v = Factory.build(:video)
    filename = 'sample.zip'
    v.path = v.store_from_source(filename, File.new(fixture_file_path(filename)))    
    v.extract_thumbnail_from_zip    
    Dimensions.dimensions(File.new(v.full_thumbnail_path)).should == [465, 349]    
  end
  
  it 'should extract thumbnail from a movie' do
    v = Factory.build(:video, :thumbnail_pos => '00:00:01')
    filename = 'video1.mpg'
    v.path = v.store_from_source(filename, File.new(fixture_file_path(filename)))    
    v.extract_thumbnail_from_movie
    Dimensions.dimensions(File.new(v.full_thumbnail_path)).should == [160, 120]
  end
  
  it 'should calculate fps correctly' do
    v = Factory.build(:video)
    fps = v.calculate_fps(25, 1000)
    fps.should == "25.0000"
  end
  
  it 'should calculate fps correctly' do
    v = Factory.build(:video)
    fps = v.calculate_fps(250, 10000)
    fps.should == "25.0000"
  end
  
  context 'when encoding from a zip' do
    
    before do     
      @video = Factory.build(:video, :thumbnail_pos => '00:00:01')
      filename = 'frames1.zip'
      @video.path = @video.store_from_source(filename, File.new(fixture_file_path(filename)))
      @video.capture_start = 0
      @video.capture_end   = 1000          
    end
    
    it 'should calculate 7 fps from 7 frames for 1 second movie' do
      @video.encode_from_zip
      @video.fps.to_f.should be_within(0.01).of(7.0)
    end   
    
    it 'should extract 1st picture as the thumbnail' do
      @video.encode_from_zip      
      dims = Dimensions.dimensions(@video.full_thumbnail_path)
      dims[0].should == 465
    end
    
    it 'should take the width from 1st image' do
      @video.encode_from_zip
      @video.width.should == 465
    end
    
    it 'should create a move file' do
      @video.encode_from_zip
      @video.full_filepath.end_with?('.mov').should be_true
    end
    
  end
  
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
    
    it 'should create 3 file_assets' do
      @video.file_assets.count.should == 3
    end
    
    it 'should create the thumbnail_file_asset' do
      @video.thumbnail_file_asset.should be
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
    
    it "updating thumbnail_pos should have no effect on the video" do
      size1 = File.size @video.full_filepath
      video = Video.find @video.id
      video.thumbnail_pos = "00:00:10"
      video.save
      size2 = File.size video.full_filepath      
      size2.should == size1
    end
    
    it "should update the thumbnail when thumbnail_pos is changed" do                  
      size1 = File.size @video.thumbnail_path
      video = Video.find @video.id
      video.thumbnail_pos = "00:00:10"
      video.save
      size2 = File.size video.thumbnail_path
      size2.should_not == size1
    end
    
    it "should remove file_assets when it's destroyed" do
      @video.destroy
      @video.file_assets.should be_empty
    end     
    
    context "overwriting the thumbnail manually" do
      before do
        filename = 'picture_160_120.png'   
        @thumbnail_upload = Uploader.new(
          :filepath           => fixture_file_path(filename),        
          :original_filename  => filename
        )                
      end    
    
      it "should overwrite the thumbnail manually if one is passed" do      
        size1 = File.size @video.thumbnail_path
        video = Video.find @video.id
        video.uploaded_thumbnail = @thumbnail_upload
        video.save
        size2 = File.size video.thumbnail_path
        size2.should_not == size1      
      end
      
      it "should overwrite the thumbnail and it should have correct dims" do      
        video = Video.find @video.id
        video.uploaded_thumbnail = @thumbnail_upload
        video.save
        Dimensions.dimensions(video.thumbnail_path).should == [160, 120]        
      end

      it "should reset the thumbnail position" do
        video = Video.find @video.id
        video.uploaded_thumbnail = @thumbnail_upload
        video.save      
        video.thumbnail_pos.should be_blank
      end
      
    end
    
  end
  
  context 'when a different MPG is uploaded' do
    before do
      filename = 'video2.MPG'   
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
    
    it 'should create one FLV copy' do      
      Dir[File.join @video.base_dir, '*.flv'].count.should == 1
    end
    
    it 'should create non-empty FLV copy' do      
      File.size(File.join @video.base_dir, @video.flv_path).should_not == 0
    end
  end
  
  context 'when a 3GPP video is uploaded' do
    before do
      filename = 'sample.3gp'   
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
    
    it 'should encode FLV from 3GPP' do      
      recoding_events = Event.where(:event_type => 'video_recode')
                        .order('id DESC').limit(2)
      first  = recoding_events.last  
      first.detail_s1.should == 'flv'
      first.detail_s2.should == 'original'
    end
    
    it 'should encode MPG from FLV (produced from 3GPP)' do      
      recoding_events = Event.where(:event_type => 'video_recode')
                        .order('id DESC').limit(2)
      last  = recoding_events.first
      last.detail_s1.should == 'mpg'
      last.detail_s2.should == 'flv'
    end
        
  end
  
  
    
end
