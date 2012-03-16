class Cropper

  def crop(image_path, x, y, width, height)
    
    img = Magick::ImageList.new(image_path)
    cropped = img.crop(x, y, width, height)
    
    cropped_path = image_path + '.cropped'
    
    cropped.write(cropped_path)
    cropped_path        
    
  end

end
