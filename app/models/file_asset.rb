module FileAsset
  
  def filepath_for_type(type)
    filepath_for_type_and_filename(type, self.path)
  end
  
  def filepath_for_type_and_filename(type, filename)
    user_id = self.block.case.user_id
    APP_CONFIG['files_path'] + "#{user_id}/#{type}" + '/' + filename
  end
  
  def full_filepath
    filepath_for_type(self.file_type)
  end  
  
  def delete_file_for_type(type)    
    filepath = filepath_for_type(type)
    File.unlink(filepath) if File.exists?(filepath)
  end
    
  def self.dir_for_user(user_id, type)
    APP_CONFIG['files_path'] + "#{user_id}/#{type}"
  end
  
  def self.store_for_type(user, file, type)
    
    s = Time.now.to_i.to_s + rand(0..999).to_s
    hash = Digest::MD5.hexdigest(s)    

    filename = hash + '-' + file.original_filename
    dir = dir_for_user(user.id, type)    
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    if File.directory?(dir)
      bytes = file.read
      filepath = dir + '/' + filename
      File.open(filepath, 'wb') {|f| f.write(bytes) }
    end
    
    filename
    
  end
  
end
