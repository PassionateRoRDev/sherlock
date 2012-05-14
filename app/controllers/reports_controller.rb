class ReportsController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :resolve_case, :except => [ :new, :create, :index ]
  
  def show
    render_pdf2(@case)
  end
  
  protected
  
  def render_pdf2(the_case)
    
    report = Report.new
    report.title = the_case.title
    report.header = current_user.letterhead
    report.case = the_case    
    report.template = 'template.xhtml'        
    
    report.generate_pdf        
    
    title = the_case.title.gsub(/\s+/, '-') + '.pdf'
    title = title.gsub('"', '')
    send_pdf_headers(title)
    
    send_file(report.reports_output_path,
              :filename => title, :type => 'application/pdf')

  end
  
  def send_pdf_headers(title)
    
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma']               = 'public'
      headers["Content-type"]         = "application/pdf" 
      headers['Cache-Control']        = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition']  = "attachment; filename=\"#{title}\"" 
      headers['Expires']              = "0" 
    else
      headers["Content-Type"] ||= 'application/pdf'
      headers["Content-Disposition"]  = "attachment; filename=\"#{title}\"" 
    end
  end  
  
  def resolve_case
    resolve_case_using_param(:id)    
  end
  
end
