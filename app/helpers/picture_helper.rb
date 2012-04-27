module PictureHelper
  
  def file_picture_path(picture)
    file_path(picture.block.case_id, 'pictures', picture.path)
  end
  
  def image_alignment_options
    [
      ['None', nil],
      ['Left', 'left'],
      ['Right', 'right'],
      ['Center', 'center']
    ]
  end
  
  def picture_dynamic_style(picture)
    
    online_width = picture.online_dims[0]
    style = "width:#{online_width}px;"
    is_narrow_elt = online_width <= Report::NARROW_ELT_WIDTH
    
    case picture.alignment
    when 'left'
      if is_narrow_elt
        style += 'float:left;margin:0 1em 1em 0'
      else
        style += 'clear:both;'
      end
    when 'right'
      if is_narrow_elt
        style += 'float:right;margin:0 0em 1em 1em'
      else
        style += 'clear:both;'
      end
    when 'center'
      style += 'text-align:center;clear:both;margin-top:1em;'
    else
      style += 'clear:both;margin-top:1em;'
    end
    
    style
    
  end
  
  def image_logo_tag_constrained(logo, max_dims)
    dims = Picture.scale_to_bounds(logo.dims, max_dims)
    link = logo_path(logo.path)
    size_string = dims[0].floor.to_s + 'x' + dims[1].floor.to_s    
    title = logo.dims ?  "Original Dimensions: #{logo.dims[0]}x#{logo.dims[1]}" : ""    
    link_to(image_tag(url_for(link), :size => size_string, :title => title), 
            link, :target => '_blank')
  end
    
end
