module VideoHelper

  def file_video_path(video, path = video.path)
    file_path(video.block.case_id, 'videos', path)
  end
  
  def video_alignment_options
    [
      ['None', nil],
      ['Left', 'left'],
      ['Right', 'right'],
      ['Center', 'center']
    ]
  end
  
  def video_dynamic_style(video)
    
    style = "width:#{video.online_dims[0]}px;"
    
    case video.alignment
    when 'left'
      if video.width <= Report::NARROW_ELT_WIDTH
        style += 'float:left;margin:0 1em 1em 0'        
      else
        style += 'clear:both'
      end
    when 'right'
      if video.width <= Report::NARROW_ELT_WIDTH
        style += 'float:right;margin:0 0em 1em 1em'
      else
        style += 'clear:both'        
      end
    when 'center'
      style += 'margin:auto;clear:both;margin-top:1em;'
    else
      style += 'clear:both;margin-top:1em;'
    end
  end
  
end
