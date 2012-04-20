class CasesController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter :authorize_pi!, :except => [ :index, :preview, :show ]
  before_filter :authorize_case_create!, :only => [:new, :create]
  before_filter :resolve_case, :except => [ :new, :create, :index ]
    
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
    
    @letterhead = @case.author.letterhead
    
    render :preview, :layout => false
  end
  
  def show    
    
    @notes = @case.notes.order('id DESC').limit(5)
    
    respond_to do |format|
      #format.xml { render :xml => @case }
      format.html {
        redirect_to :action => :preview unless current_user.pi?
      }     
      format.pdf { render_pdf2(@case) }
      format.js { render :json => @case }
    end
  end
  
  def update
    
    if @case      
      
      params[:case] = convert_dates(params[:case])
      params[:case] = preparse_hinted(params[:case], params[:hinted])
      
      logger.debug params
            
      respond_to do |format|
        if @case.update_attributes(params[:case])
          format.html { redirect_to(@case, :notice => 'Case has been successfully updated') }
          format.js
        else
          foreat.html { render :action => 'edit' }
          format.js
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
    
    @folders = current_user.folders    
    @cases =  cases_for_user
    
  end
  
  private
    
  def cases_for_user
    if current_user.pi?
      current_user.cases.select { |c| c.folder_id == nil }
    else
      current_user.cases
    end
  end
  
  def resolve_case
    resolve_case_using_param(:id)
  end
  
  def render_pdf2(the_case)
    
    report = Report.new
    report.title = the_case.title
    report.header = current_user.letterhead
    report.case = the_case    
    report.template = 'template.xhtml'        
    
    report.generate_pdf        
    
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
  
  def preparse_hinted(params, hinted)    
    hinted.to_a.each do |key, value|      
      params[key.to_sym] = '' if value.to_i == 1      
    end        
    params    
  end
  
  def convert_date(date_string)
    if date_string.to_s =~ /(\d\d)\/(\d\d)\/(\d{4})/
      date_string = "#{$3}-#{$1}-#{$2}"
    end
    date_string
  end
  
  def upgrade_or_purchase
    @plans = current_user.plans_to_upgrade
    render 'upgrade_or_purchase'
  end
  
  def authorize_case_create!
    upgrade_or_purchase unless current_user.can_create_case?
  end
  
  def convert_dates(params)    
    params['opened_on']   = convert_date(params['opened_on'])
    params['closed_on']   = convert_date(params['closed_on'])
    params['report_date'] = convert_date(params['report_date'])
    params
  end
    
end
