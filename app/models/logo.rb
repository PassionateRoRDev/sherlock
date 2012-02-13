class Logo
  
  attr_accessor :path
  attr_accessor :content_type  
  
  def initialize(params = {})
    self.content_type   = params[:content_type]
    self.path           = params[:path]
  end
  
end
