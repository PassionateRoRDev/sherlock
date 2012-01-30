class Report
  
  attr_accessor :case
  attr_accessor :title
  attr_accessor :output_file
  
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
      'case'          => self.case.as_json(options)
    }
  end
  
  def reports_output_path
    ("reports/#{self.case.user.id}/#{self.output_file}").gsub('//', '/')
  end
  
  def pictures_root
    (APP_CONFIG['files_path'] + "/#{self.case.user.id}/pictures/").gsub('//', '/')
  end
  
  def videos_root
    (APP_CONFIG['files_path'] + "/#{self.case.user.id}/videos/").gsub('//', '/')
  end
  
end
