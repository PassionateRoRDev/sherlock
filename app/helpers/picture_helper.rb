module PictureHelper
  
  def image_tag_constrained(obj, max_dims)    
    
    dims = Picture.scale_to_bounds(obj.dims, max_dims)
    
    link = file_path(obj.file_type, obj.path)
    
    size_string = dims[0].floor.to_s + 'x' + dims[1].floor.to_s
    title = "Original Dimensions: #{obj.dims[0]}x#{obj.dims[1]}"
        
    link_to(image_tag(url_for(link), :size => size_string, :title => title), 
            link, :target => '_blank')
  end    
  
end