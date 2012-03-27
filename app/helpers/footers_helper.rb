module FootersHelper

  def footer_path(kase)
    footer = kase.footer    
    footer ? edit_case_footer_path(kase, footer) : new_case_footer_path(kase)          
  end
  
  def footer_style(footer)  
    result = "text-align:#{footer.text_align};"
    result += "font-size:#{footer.font_size}px;"
    result += "font-weight:bold;"
    result += "color:#{footer.font_color};"        
  end
end
