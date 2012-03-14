module VideoHelper
  
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
      style += 'float:left;margin:0 1em 1em 0'
    when 'right'
      style += 'float:right;margin:0 0em 1em 1em'
    when 'center'
      style += 'margin:auto;clear:both;margin-top:1em;'
    else
      style += 'clear:both;margin-top:1em;'
    end
  end
  
end