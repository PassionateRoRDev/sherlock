def video_from_file(filename, thumbnail_pos)  
  data = {
    :filepath           => fixture_file_path(filename),        
    :original_filename  => filename
  }
  upload = Uploader.new(data)
  video = FactoryGirl.create(:video, 
    :uploaded_file      => upload,
    :thumbnail_pos      => thumbnail_pos
  )
  video.uploaded_file = nil
  video
end