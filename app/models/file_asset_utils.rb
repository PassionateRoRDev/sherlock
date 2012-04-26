require 'digest/md5'

module FileAssetUtils
        
  def author
    self.block ? self.block.case.author : nil
  end
  
  def author_id
    author ? author.id : 0   
  end
  
  def base_dir
    mount_point + "#{author_id}/#{file_type}"
  end
  
  def filepath_for_filename(filename)
    File.join base_dir, filename    
  end
  
  def full_filepath
    filepath_for_filename self.path
  end  
    
  def path_for_suffix(suffix, path = self.path)
    path.sub(/([^.]+)$/, suffix.to_s)    
  end
  
  def full_path_for_suffix(suffix)
    filepath_for_filename path_for_suffix(suffix)    
  end
  
  def recover_original_filename
    original_filename_from_path self.path
  end
  
  def original_filename_from_path(p)
    p.sub(/\A[a-z0-9]{32}-/, '')
  end
  
  def file_size(path = nil)
    path = full_filepath if path.nil?
    File.exists?(path) ? File.size(path) : 0
  end  
    
  def delete_file
    filepath = full_filepath
    File.unlink(filepath) if filepath && File.exists?(filepath)
  end
    
  def mount_point
    "#{Rails.root}/" + APP_CONFIG['files_path']
  end
            
  #
  # TODO: use 'original_filename_from_path' instead of 'sub'
  #
  def generate_new_filename(original_filename)
    s = Time.now.to_i.to_s + rand(999).to_s
    hash = Digest::MD5.hexdigest(s) 
    original_filename = original_filename.gsub('#', '').gsub(/\s+/, ' ')
    hash += ('-' + original_filename.sub(/\A[a-z0-9]{32}-/, ''))
    hash.downcase    
  end
    
  def store_from_source(effective_filename, source)
    filename = generate_new_filename effective_filename
    dir = base_dir
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    full_path = File.join dir, filename
    File.open(full_path, 'wb') { |f| f.write source.read } if File.directory?(dir)  
    filename
  end
  
  def store(effective_filename, bytes)
    filename = generate_new_filename effective_filename    
    dir = base_dir
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    path = File.join(dir, filename)
    File.open(path, 'wb') { |f| f.write(bytes) } if File.directory?(dir)            
    filename
  end    
  
end
