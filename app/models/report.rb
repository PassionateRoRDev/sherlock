class Report
  
  attr_accessor :case
  attr_accessor :title
  attr_accessor :output_file
  attr_accessor :template
  attr_accessor :header  
  
  def initialize(params = {})
    self.case         = params[:case]
    self.title        = params[:title]
    self.header       = params[:header]
    self.output_file  = params[:output_file]
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
    
  def write_json
    dir = reports_root
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    
    json_path = reports_output_path.sub(/\.pdf$/, '.json')    
    File.open(json_path, 'w') {|f| f.write(to_json) }
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
