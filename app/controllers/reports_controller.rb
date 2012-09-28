class ReportsController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :resolve_case, :except => [ :new, :create, :index ]
  
  def show
    if @case.is_static
      render_static_document @case
    else
      render_pdf2(@case)
    end
  end
  
  protected
  
  def render_static_document(the_case)
    
    doc = the_case.document
    file_asset = doc.file_assets.first    
    title = doc.original_filename    
    
    pp "Path: #{file_asset.full_filepath}" 
    pp "Title: #{title}"
    
    send_headers(file_asset.content_type, title)    
    send_file(file_asset.full_filepath,
              :filename => title, :type => file_asset.content_type)    
  end
  
  def render_pdf2(the_case)
    
    report = Report.new
    report.title = the_case.title
    report.header = current_user.letterhead
    report.case = the_case    
    report.template = 'template.xhtml'        
    
    report.generate_pdf        
    
    title = the_case.title.strip.gsub(/\s+/, '-') + '.pdf'
    title = title.gsub('"', '')
    send_pdf_headers(title)
    
    send_file(report.reports_output_path,
              :filename => title, :type => 'application/pdf')

  end
  
  def send_headers(content_type, title)
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma']               = 'public'
      headers["Content-type"]         = content_type 
      headers['Cache-Control']        = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition']  = "attachment; filename=\"#{title}\"" 
      headers['Expires']              = "0" 
    else
      headers["Content-Type"] ||= content_type
      headers["Content-Disposition"]  = "attachment; filename=\"#{title}\"" 
    end
  end
  
  def send_pdf_headers(title)
    send_headers('application/pdf', title)        
  end  
  
  def resolve_case
    resolve_case_using_param(:id)    
  end
  
end
