class LogoSpecHelper
  
  attr_accessor :filepath
  
  def upload_file(filename, content_type)    
      user = Factory(:user)      
      self.filepath = fixture_file_path(filename)      
      upload = Uploader.new(
        :filepath           => filepath,
        :original_filename  => filename,
        :content_type       => content_type
      )    
      path = Logo.store(user, upload)    
      Factory(:logo, 
        :user => user, 
        :path => path,
        :content_type => upload.content_type
      )
  end
  
end
