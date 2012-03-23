class Uploader
  
  attr_accessor :filepath, :original_filename
  
  def initialize(options = {})    
    options.each do |field, value|
      self.send("#{field}=", value)
    end
    @read = 0
  end
    
  def read   
    @read += 1
    File.open(filepath, 'rb').read if @read == 1
  end
  
end