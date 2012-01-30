require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def prepare_case
  u = User.new
  u.id = 1
  c = Case.new(:title => 'Case #170', :summary => 'Summary!')  
  c.user = u
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
    decoded["outputFile"].should == 'reports/1/report1.pdf'
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
  
end

