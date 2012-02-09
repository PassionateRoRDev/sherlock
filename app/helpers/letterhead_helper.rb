module LetterheadHelper
  
  def font_size_options   
    [10, 12, 14, 16].map do |size|
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
    [10, 12, 14, 16].map do |size|
      ["#{size} px", size]
    end        
  end
  
  def divider_width_options
    [75, 100, 125, 100].map do |width|
      ["#{width} %", width]
    end    
  end
  
end

