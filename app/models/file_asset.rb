module FileAsset
  
  def delete_file_for_path(filepath, type)    
    user_id = self.block.case.user_id
    dir = APP_CONFIG['files_path'] + "#{user_id}/#{type}"
    filepath = dir + '/' + self.path
    File.unlink(filepath) if File.exists?(filepath)
  end
  
  def self.store_for_type(user, file, type)
    
    s = Time.now.to_i.to_s + rand(0..999).to_s
    hash = Digest::MD5.hexdigest(s)    

    filename = hash + '-' + file.original_filename
    
    dir = APP_CONFIG['files_path'] + "#{user.id}/#{type}"
    FileUtils.mkdir_p(dir) unless File.directory?(dir)    
    if File.directory?(dir)
      bytes = file.read
      filepath = dir + '/' + filename
      File.open(filepath, 'wb') {|f| f.write(bytes) }
    end
    
    filename
    
  end
  
end
