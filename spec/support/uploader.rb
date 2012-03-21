class Uploader
  
  attr_accessor :filepath, :original_filename
  
  def initialize(options = {})    
    options.each do |field, value|
      self.send("#{field}=", value)
    end
    
  end
    
  def read    
    File.open(filepath, 'rb').read    
  end
  
end