module LetterheadHelper
  
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

