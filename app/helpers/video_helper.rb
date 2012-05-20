module VideoHelper

  def file_video_path(video, path = video.path)
    file_path(video.block.case_id, 'videos', path)
  end
  
  def video_thumbnail_path(video)    
    asset = video.thumbnail_file_asset
    file_video_thumbnail_path(video.block.case_id, asset.path)
  end
  
  def thumbnail_pos(video)
    video.thumbnail_pos || '00:00:01'
  end
  
  def video_alignment_options
    [
      ['None', nil],
      ['Left', 'left'],
      ['Right', 'right'],
      ['Center', 'center']
    ]
  end
  
  def video_scaling_options
    [
      ['None', nil],
      ['50%', '50']      
    ]
  end
  
  def video_dynamic_style(video)
        
    online_width = video.online_dims[0]
    style = "width:#{online_width}px;"
    is_narrow_elt = online_width <= Report::NARROW_ELT_WIDTH
      
    case video.alignment
    when 'left'
      if is_narrow_elt
        style += 'float:left;margin:0 1em 1em 0'        
      else
        style += 'clear:both'
      end
    when 'right'
      if is_narrow_elt
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
