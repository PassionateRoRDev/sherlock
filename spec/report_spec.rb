require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def prepare_case
  u = User.new
  u.id = 1
  c = Case.new(:title => 'Case #170', :summary => 'Summary!')  
  c.author = u
  c  
end

def prepare_report(c = nil)
  c = prepare_case unless c
  Report.new(:title => 'Report Title', 
             :case => c, 
             :output_file => 'report1.pdf')
  
end

describe Report do
  it 'JSON should have correct title' do
    r = prepare_report
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["title"].should == 'Report Title'
  end
  
  it 'JSON should have correct output file' do
    r = prepare_report
    decoded = ActiveSupport::JSON.decode(r.to_json)
    
    files_path = "#{Rails.root}/#{APP_CONFIG['files_path']}"
    
    decoded["outputFile"].should == "#{files_path}1/reports/report1.pdf"
  end
  
  it 'JSON should have correct number of blocks' do
    c = prepare_case
    block1 = Block.new
    block1.html_detail = HtmlDetail.new(:contents => 'Contents of the first HTML block')
    c.blocks << block1
    
    r = prepare_report(c)
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'].count.should == 1
  end
  
  it 'JSON should have correct number of blocks' do
    c = prepare_case
    
    block1 = Block.new
    block1.html_detail = HtmlDetail.new(:contents => 'Contents of the first HTML block')
    c.blocks << block1
    
    block2 = Block.new
    block2.picture = Picture.new(:title => 'Title of the picture', :path => 'picture1.png')
    c.blocks << block2
    
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
  
  it 'JSON should contain picturesRoot and it should be absolute' do
    r = prepare_report
    r.template = 'template.xhtml'
    
    files_path = "#{Rails.root}/#{APP_CONFIG['files_path']}"
    
    decoded = ActiveSupport::JSON.decode(r.to_json)    
    decoded['picturesRoot'].should == "#{files_path}1/pictures/"    
  end
  
  it 'Picture block should return its title as a caption' do
    c = prepare_case
    
    block1 = Block.new
    block1.html_detail = HtmlDetail.new(:contents => 'Contents of the first HTML block')
    c.blocks << block1
    
    block2 = Block.new
    block2.picture = Picture.new(:title => 'Title of the picture', :path => 'picture1.png')
    c.blocks << block2
    
    r = prepare_report(c)
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'][1]['picture']['caption'].should == 'Title of the picture'
  end
  
  it 'Video block should return its title as a caption' do
    c = prepare_case
    
    block1 = Block.new
    block1.html_detail = HtmlDetail.new(:contents => 'Contents of the first HTML block')
    c.blocks << block1
    
    block2 = Block.new
    block2.video = Video.new(
      :title        => 'Title of the video', 
      :path         => 'video1.mpg',
      :content_type => 'video/mpeg'
    )
    c.blocks << block2
    
    r = prepare_report(c)
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'][1]['video']['caption'].should == 'Title of the video'
  end
  
  it 'Video block should return its dimensions' do
    c = prepare_case
    
    block1 = Block.new
    block1.html_detail = HtmlDetail.new(:contents => 'Contents of the first HTML block')
    c.blocks << block1
    
    block2 = Block.new
    block2.video = Video.new(
      :title => 'Title of the video', 
      :path => 'video1.mpg',
      :type => 'mpeg',
      :content_type => 'video/mpeg',
      :thumbnail => 'thumbnail1.png',
      :width  => 300,
      :height => 200      
    )
    c.blocks << block2
    
    r = prepare_report(c)
    
    decoded = ActiveSupport::JSON.decode(r.to_json)
    decoded["case"]['blocks'][1]['video']['width'].should == 300
    decoded["case"]['blocks'][1]['video']['height'].should == 200
  end
  
end

