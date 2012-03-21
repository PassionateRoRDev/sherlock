class Uploader
  
  attr_accessor :filepath, :original_filename
  
  def initialize(options = {})    
    options.each do |field, value|
      self.send("#{field}=", value)
    end
    
  end
  
  def seek(offset)    
  end
  
  def read    
    File.open(filepath, 'rb').read    
  end
  
end