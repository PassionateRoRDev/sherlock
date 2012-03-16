class Cropper

  def crop(image_path, x, y, width, height)
    
    width = width.to_i
    height = height.to_i
    
    cropped_path = nil
    
    if (width > 0) && (height > 0)
      img = Magick::ImageList.new(image_path)
      cropped = img.crop(x.to_i, y.to_i, width.to_i, height.to_i)

      cropped_path = image_path + '.cropped'
      cropped.write(cropped_path)
    end
    
    cropped_path
    
  end

end
