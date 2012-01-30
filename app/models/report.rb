class Report
  
  attr_accessor :case
  attr_accessor :title
  attr_accessor :output_file
  attr_accessor :template
  
  def initialize(params = {})
    self.case         = params[:case]
    self.title        = params[:title]
    self.output_file  = params[:output_file]
  end
  
  def as_json(options = {})
    {
      'title'         => self.title,
      'outputFile'    => reports_output_path,
      'picturesRoot'  => pictures_root,
      'videosRoot'    => videos_root,      
      'templatesRoot' => templates_root,
      'template'      => self.template,
      'case'          => self.case.as_json(options)
    }
  end
  
  def files_path
    "#{Rails.root}/#{APP_CONFIG['files_path']}/"    
  end
  
  def files_path_for_user
    "#{files_path}/#{self.case.user.id}/"
  end
      
  def templates_root
    "#{Rails.root}/#{APP_CONFIG['templates_path']}"    
  end
  
  def path_for(name)    
    normalize_path(files_path_for_user + "/#{name}/")
  end
  
  def reports_output_path
    normalize_path("#{path_for('reports')}/#{self.output_file}")
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
