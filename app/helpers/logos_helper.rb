module LogosHelper
  
  def file_logo_path(kase, logo)
    file_path(kase.id, 'logos', logo.path)
  end
  
end