class LogoSpecHelper
  
  attr_accessor :filepath
  
  def upload_file(filename, content_type)    
    self.filepath = fixture_file_path(filename)
    upload = Uploader.new(
      :filepath           => self.filepath,
      :original_filename  => filename,
      :content_type       => content_type
    )      
    Factory(:logo, :uploaded_file => upload)
  end
  
end
