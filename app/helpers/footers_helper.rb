module FootersHelper

  def footer_path(kase)
    footer = kase.footer    
    footer ? edit_case_footer_path(kase, footer) : new_case_footer_path(kase)          
  end

end
