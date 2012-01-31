module FileAsset
  
  def filepath_for_type(type)
    filepath_for_type_and_filename(type, self.path)
  end

  def filepath_for_type_and_filename(type, filename)
    user_id = self.block.case.user_id
    FileAsset::dir_for_user(user_id, type) + '/' + filename
  end
  
  def full_filepath
    filepath_for_type(self.file_type)
  end  
  
  def delete_file_for_type(type)    
    filepath = filepath_for_type(type)
    File.unlink(filepath) if File.exists?(filepath)
  end
    
  def self.dir_for_user(user_id, type)
    "#{Rails.root}/" + APP_CONFIG['files_path'] + "#{user_id}/#{type}"
  end
  
  def self.generate_new_filename(original_filename)
    s = Time.now.to_i.to_s + rand(0..999).to_s
    hash = Digest::MD5.hexdigest(s)    
    hash + '-' + original_filename    
  end
  
  def self.store_for_type(user, file, type)
    
    filename = generate_new_filename(file.original_filename)    
    
    dir = dir_for_user(user.id, type)    
    Rails::logger.debug("Creating dir if does not exist: " + dir)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    if File.directory?(dir)
      bytes = file.read
      filepath = dir + '/' + filename
      File.open(filepath, 'wb') {|f| f.write(bytes) }
    end
    
    filename
    
  end
  
end
