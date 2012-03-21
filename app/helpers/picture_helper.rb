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
    case picture.alignment
    when 'left'
      'float:left;margin:0 1em 1em 0'
    when 'right'
      'float:right;margin:0 0em 1em 1em'
    when 'center'
      'text-align:center;clear:both;margin-top:1em;'
    else
      'clear:both;margin-top:1em;'
    end
  end
  
  def image_tag_constrained(obj, max_dims)    
    
    dims = Picture.scale_to_bounds(obj.dims, max_dims)
    
    case_id = obj.case_id    
    link = file_path(case_id, obj.file_type, obj.path)
    
    size_string = dims[0].floor.to_s + 'x' + dims[1].floor.to_s
    title = obj.dims ?  "Original Dimensions: #{obj.dims[0]}x#{obj.dims[1]}" : ""
        
    link_to(image_tag(url_for(link), :size => size_string, :title => title), 
            link, :target => '_blank')
  end    
  
end
