class Report
  
  attr_accessor :case
  attr_accessor :title  
  attr_accessor :template
  attr_accessor :header  
  
  MAX_PAGE_WIDTH = 750
  NARROW_ELT_WIDTH = (MAX_PAGE_WIDTH / 2) + 20
  
  PDF_RETRY_COUNT = 5
  RETRY_SLEEP_INTERVAL = 2
  
  def initialize(params = {})
    self.case         = params[:case]
    self.title        = params[:title]
    self.header       = params[:header]    
  end
    
  def destroy_report    
    report_pdf_path = reports_output_path    
    File.delete report_pdf_path if File.exists? report_pdf_path    
  end

  def self.invalidate_for_case(case_id)    
    r = Report.new
    r.case = Case.find(case_id)    
    r.destroy_report
    
  end  
  
  def self.invalidate_for_user(user_id)
    Case.where(:author_id => user_id).each { |c| invalidate_for_case c.id }          
  end
  
  def as_json(options = {})
    
    header_options = {
      :camelize => true,
      :except => [:id, :user_id, :created_at, :updated_at],
      :include  => [:logo]
    }
    footer_options = {
      :camelize => true,
      :except => [:id, :case_id, :created_at, :updated_at]
    }
        
    {
      'title'         => self.title,
      'header'        => self.header.as_json(header_options),
      'footer'        => self.case.footer.as_json(footer_options),
      'outputFile'    => reports_output_path,
      'logosRoot'     => logos_root,
      'picturesRoot'  => pictures_root,
      'videosRoot'    => videos_root,      
      'templatesRoot' => templates_root,
      'template'      => self.template,
      'case'          => self.case.as_json(options)
    }
  end
    
  def generate_pdf   
    
    report_pdf_path = reports_output_path
    
    # disable report caching:
    #File.unlink report_pdf_path if File.exists?(report_pdf_path)
    
    unless File.exists? report_pdf_path
    
      options = {
        :for_pdf => true
      }    
      
      Rails::logger.debug 'Generate pdf - writing json'    
      path = write_json(options)
      command = "java -jar #{Rails.root}/script/ReportGen.jar " + path + " 2>&1"
      Rails::logger.debug command    
      run_command_with_retry(command, PDF_RETRY_COUNT)    
      File.unlink(path) if File.exists?(path)        
      
    end
    
  end
  
  def run_command_with_retry(command, try_count)
    
    success = false
    until success || (try_count == 0)   
      begin
        #if try_count == PDF_RETRY_COUNT
        #  Rails::logger.info("Raising Errno::ENOMEM")
        #  raise Errno::ENOMEM
        #end
        result = `#{command}`
        Rails::logger.debug "Result of command:"
        Rails::logger.debug result
        success = true
      rescue Errno::ENOMEM
        Rails::logger.error "Errno::ENOMEM"
        Rails::logger.error "Command failed! Retry count = #{try_count}"
        try_count -= 1
        Rails::logger.info "Falling asleep..."
        sleep(RETRY_SLEEP_INTERVAL) if try_count > 0
        Rails::logger.info "Waking up"
      rescue        
        Rails::logger.error "Command failed! Retry count = #{try_count}"
        try_count -= 1
        Rails::logger.info "Falling asleep..."
        sleep(RETRY_SLEEP_INTERVAL) if try_count > 0
        Rails::logger.info "Waking up"
      end
    end        
  end
  
  def write_json(options = {})
    
    dir = reports_root
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    
    json_path = reports_output_path.sub(/\.pdf$/, '.json')
    Rails::logger.debug "JSON PATH: #{json_path}"
    
    File.open(json_path, 'w') { |f| f.write(to_json(options)) }
    json_path
  end
  
  def files_path
    "#{Rails.root}/#{APP_CONFIG['files_path']}/"    
  end
  
  def files_path_for_author
    "#{files_path}/#{self.case.author_id}/"
  end
      
  def templates_root
    "#{Rails.root}/#{APP_CONFIG['templates_path']}"    
  end
  
  def path_for(name)    
    normalize_path(files_path_for_author + "/#{name}/")
  end
    
  def output_file_for_case_id(case_id)
    "report_#{case_id}.pdf"
  end
  
  def output_file
    output_file_for_case_id self.case.id    
  end
  
  def reports_output_path
    normalize_path("#{reports_root}/#{self.output_file}")
  end
  
  def logos_root
    path_for('logos')
  end
  
  def reports_root
    path_for('reports')    
  end  
  
  def pictures_root
    path_for('pictures')    
  end
  
  def videos_root
    path_for('videos')
  end
  
  def normalize_path(path)
    path.gsub(/\/+/, '/')
  end
  
end
