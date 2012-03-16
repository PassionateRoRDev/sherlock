module LogosHelper
  
  def file_logo_path(kase, logo)
    case_id = kase ? kase.id : 0
    file_path(case_id, 'logos', logo.path)
  end
  
end