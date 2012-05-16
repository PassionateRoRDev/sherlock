module LetterheadHelper
  
  def letterhead_style_for_header(letterhead)
    
    if letterhead.logo && letterhead.contents.to_s.blank?
      dims = letterhead.logo.dimensions      
      height = dims[1]
      height = 80 if height > 80
      "height:#{height}px;"
    else
      ''
    end
    
  end
  
  def letterhead_style(letterhead)
  
    result = "text-align:#{letterhead.text_align};"
    result += "font-size:#{letterhead.font_size}px;"
    result += "font-weight:bold;"
    result += "color:#{letterhead.font_color};"
    
    floated = letterhead_float(letterhead.alignment)    
    result += "float:#{floated};" if floated.present? 
      
    result
  end
  
  def letterhead_logo_wrapper_style(letterhead)
    
    result = 'position:absolute;'
    
    floated = letterhead_float(letterhead.logo_alignment)
    if floated.present?
      result += "#{floated}:0;"      
    else
      result += 'width:100%;text-align:center;'
    end
        
    result
  end
    
  def letterhead_float(alignment)    
    ['left', 'right'].include?(alignment) ? alignment : ''
  end              
  
  def font_face_options
    [
      ['Arial', 'arial'],
      ['Helvetica', 'helvetica'],
      ['Verdana', 'verdana']
    ]
  end
  
  def font_size_options   
    [10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26].map do |size|
      ["#{size} px", size]
    end        
  end
  
  def align_options
    [
      ['Left', 'left'],
      ['Center', 'center'],
      ['Right', 'right']
    ]
  end
  
  def text_align_options
    align_options
  end
  
  def logo_align_options
    align_options
  end
  
  def divider_size_options   
    [1, 2, 3, 4, 5, 10, 12, 14, 16].map do |size|
      ["#{size} px", size]
    end        
  end
  
  def divider_width_options
    [50, 60, 65, 75, 80, 85, 100].map do |width|
      ["#{width} %", width]
    end    
  end
  
end

