class UploaderFromResource

  attr_accessor :original_filename, :content_type, :filepath
  
  def initialize(options = {})    
    options.each do |field, value|
      self.send("#{field}=", value)
    end    
  end
    
  def read    
    File.open(self.filepath, 'rb').read    
  end

end
