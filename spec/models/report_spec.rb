require 'spec_helper'

describe Report do
  
  def prepare_case
    FactoryGirl.create(:case, :author => FactoryGirl.create(:user))  
  end

  def prepare_report(c = nil)      
    FactoryGirl.build(:report, :case => c || prepare_case)    
  end
  
  it 'JSON should have correct title' do
    r = prepare_report
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["title"].should == r.title
  end
  
  it 'JSON should have correct output file' do
    r = prepare_report
    decoded = ActiveSupport::JSON.decode(r.to_json)    
    decoded["outputFile"].should == "#{r.reports_root}#{r.output_file}"   
  end
  
  it 'JSON should have correct number of blocks' do
    c = prepare_case    
    c.blocks << Block.new(
      :html_detail => HtmlDetail.new(:contents => 'Contents of the first HTML block'))
    
    r = prepare_report(c)
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'].count.should == 1
  end
  
  it 'JSON should contain data_log block details' do
    c = prepare_case
    log_detail = FactoryGirl.create(:data_log_detail)
    c.blocks << Block.new(:data_log_detail => log_detail)
    r = prepare_report(c)        
    decoded = ActiveSupport::JSON.decode(r.to_json)
    block = decoded['case']['blocks'][0]
    log_detail = block['dataLogDetail']
    log_detail['day'] == '05/03/2012'
    log_detail['location'] == 'New York City'        
  end
  
  it 'JSON should have correct number of blocks' do
    
    c = prepare_case    
    c.blocks << FactoryGirl.create(:block, :html_detail => FactoryGirl.create(:html_detail))    
    c.blocks << FactoryGirl.create(:block, :picture => FactoryGirl.build(:picture))    
    r = prepare_report(c)        
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'].count.should == 2
  end
  
  it 'JSON should contain templatesRoot and template' do
    r = prepare_report
    r.template = 'template.xhtml'
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded['templatesRoot'].should == "#{Rails.root}/templates/"
    decoded['template'].should == 'template.xhtml'    
  end
    
  it 'JSON should not contain picturesRoot' do    
    r = prepare_report
    r.template = 'template.xhtml'    
    
    pp r.to_json
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded['picturesRoot'].should == nil
  end
  
  it 'JSON should not contain videosRoot' do    
    r = prepare_report
    r.template = 'template.xhtml'    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded['videosRoot'].should == nil
  end
  
  it 'JSON should not contain logosRoot' do
    r = prepare_report
    r.template = 'template.xhtml'    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded['logosRoot'].should == nil
  end
  
  it 'Picture block should return its title as a caption' do
    
    picture_title = 'Title of the picture'
    
    c = prepare_case    
    c.blocks << FactoryGirl.create(:block, :html_detail => FactoryGirl.create(:html_detail))    
    c.blocks << FactoryGirl.create(:block, :picture => FactoryGirl.build(:picture, :title => picture_title))    
    r = prepare_report(c)    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'][1]['picture']['caption'].should == picture_title
  end
  
  it 'Video block should return its title as a caption' do
    c = prepare_case
    
    c.blocks << Block.new(
      :html_detail => HtmlDetail.new(:contents => 'Contents of the first HTML block'))
    
    c.blocks << Block.new(
      :video => Video.new(
        :title        => 'Title of the video', 
        :path         => 'video1.mpg',
        :content_type => 'video/mpeg'
      )
    )
    
    r = prepare_report(c)
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'][1]['video']['caption'].should == 'Title of the video'
  end
  
  it 'Video block should return its dimensions' do
    c = prepare_case
    
    c.blocks << Block.new(
      :html_detail => HtmlDetail.new(:contents => 'Contents of the first HTML block'))
    
    c.blocks << Block.new(
      :video => Video.new(
        :title => 'Title of the video', 
        :path => 'video1.mpg',
        :type => 'mpeg',
        :content_type => 'video/mpeg',
        :thumbnail => 'thumbnail1.png',
        :width  => 300,
        :height => 200
      )
    )    
    
    r = prepare_report(c)
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'][1]['video']['width'].should == 300
    decoded["case"]['blocks'][1]['video']['height'].should == 200
  end
  
  it 'Video block should return MPG as the format for the report' do
    
    c = prepare_case    
    c.blocks << Block.new(:html_detail => FactoryGirl.create(:html_detail))    
    video = video_from_file('video1.mpg', '00:00:01')              
    c.blocks << Block.new(:video => video)    
    r = prepare_report(c)    
    options = {
      :for_pdf => true
    }        
    decoded = ActiveSupport::JSON.decode(r.to_json(options))    
    video_block = decoded["case"]['blocks'][1]['video']    
    video_block['type'].should == 'mpeg'    
#    video_block['path'].should == 'video1.mpg'        
  end
  
end

