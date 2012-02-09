class CasesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :resolve_case_from_id, :except => [ :new, :create, :index ]
  
  def new
    @case = Case.new
  end
  
  def create
    
    @case = Case.new(params[:case])
    @case.author = current_user
    respond_to do |format|
      if (@case.save) 
        format.html { redirect_to(cases_path, :notice => 'Case has been successfully created') }
      else  
        format.html { render :action => 'new' }
      end
    end        
    
  end
  
  def preview    
    render :preview, :layout => false
  end
  
  def show        
    respond_to do |format|
      format.xml { render :xml => @case }
      format.html      
      format.pdf { render_pdf2(@case) }
      format.js { render :json => @case }
    end
  end
  
  def update    
    if @case
      respond_to do |format|
        if @case.update_attributes(params[:case])
          format.html { redirect_to(@case, :notice => 'Case has been successfully updated') }
        else
          foreat.html { render :action => 'edit' }
        end
      end
    end
  end
  
  def destroy   
    @case.destroy
    
    respond_to do |format|
      format.html { redirect_to(cases_path, :notice => 'The case was successfully deleted') }
    end
    
  end
  
  def edit    
  end
  
  def index
    @cases = current_user.cases
  end
  
  private
  
  def resolve_case_from_id
    @case = current_user.cases.find_by_id(params[:id]) || redirect_to(cases_path)    
  end
  
  def render_pdf2(the_case)
    
    report = Report.new
    report.title = the_case.title    
    report.case = the_case
    report.output_file = "report_#{the_case.id}.pdf"
    report.template = 'template.xhtml'
    
    logger.debug(report.to_json)
    
    path = report.write_json
    command = "java -jar #{Rails.root}/script/ReportGen.jar " + path + " 2>&1"
    logger.debug(command)
    result = `#{command}`
    logger.debug("Result of command:")
    logger.debug(result)
    
    File.unlink(path) if File.exists?(path)    
    
    title = the_case.title.gsub(/\s+/, '-') + '.pdf'    
    send_pdf_headers(title)
    
    send_file(report.reports_output_path,
              :filename => title, :type => 'application/pdf')

  end
  
  def send_pdf_headers(title)
    
    title = title.gsub(/\s+/, '-') + '.pdf'    
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "application/pdf" 
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{title}\"" 
      headers['Expires'] = "0" 
    else
      headers["Content-Type"] ||= 'application/pdf'
      headers["Content-Disposition"] = "attachment; filename=\"#{title}\"" 
    end
  end
  
  def render_pdf(the_case)
    title = the_case.title.gsub(/\s+/, '-') + '.pdf'    
    send_pdf_headers(title)
    
    send_file("#{Rails.root}/files/report1.pdf", 
              :filename => title, :type => 'application/pdf')        
    
  end

end
