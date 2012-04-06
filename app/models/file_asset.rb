require 'RMagick'

module FileAsset
  
  #
  # EPS file can mean several things:
  # - 'normal' Postscript file, starts with %!PS
  # 
  # - DOS EPS file; starts with the 30-byte long header:
  #   - 0-3 Must be hex C5D0D3C6 (byte 0=C5).
  #   - 4-7 Byte position in file for start of PostScript language code section.
  #   - 8-11 Byte length of PostScript language section.
  #   - 12-15 Byte position in file for start of Metafile screen representation.
  #   - 16-19 Byte length of Metafile section (PSize).
  #   - 20-23 Byte position of TIFF representation.
  #   - 24-27 Byte length of TIFF section.  
  #   - 28-29 Checksum of header (XOR of bytes 0-27). If Checksum is FFFF 
  #           then ignore it. 
  #
  def self.is_eps?(bytes)
    is_normal_eps?(bytes) || is_dos_eps?(bytes)
  end
  
  def filepath_for_type(type)
    filepath_for_type_and_filename(type, self.path)
  end
  
  def author
    self.block ? self.block.case.author : nil
  end
  
  def author_id
    author ? author.id : nil    
  end

  def self.filepath_for_type_filename_and_author(type, filename, author_id)
    filename ? dir_for_author(author_id, type) + '/' + filename : nil
  end
  
  def filepath_for_type_and_filename(type, filename)
    FileAsset::filepath_for_type_filename_and_author(type, filename, author_id)
  end
    
  def path_for_suffix(suffix, path = self.path)
    path.sub(/([^.]+)$/, suffix.to_s)    
  end
  
  def full_path_for_suffix(suffix)
    filepath_for_type_and_filename(file_type, path_for_suffix(suffix))        
  end
  
  def file_size(path = nil)
    path = full_filepath if path.nil?
    File.exists?(path) ? File.new(path).size : 0
  end  
  
  def full_filepath
    filepath_for_type file_type
  end
  
  def delete_file_for_type(type)    
    filepath = filepath_for_type(type)    
    File.unlink(filepath) if filepath && File.exists?(filepath)
  end
    
  def self.dir_for_author(author_id, type)
    "#{Rails.root}/" + APP_CONFIG['files_path'] + "#{author_id}/#{type}"
  end
  
  def self.dimensions_for_bytes(bytes)
    stream = StringIO.new(bytes)
    dims = Dimensions(stream)
    stream.read
    [dims.width.to_i, dims.height.to_i]
  end
      
  def self.generate_new_filename(original_filename)
    s = Time.now.to_i.to_s + rand(0..999).to_s
    hash = Digest::MD5.hexdigest(s)    
    hash + '-' + original_filename    
  end
  
  def store(effective_filename, bytes)
    filename = FileAsset::generate_new_filename effective_filename
    dir = FileAsset::dir_for_author(author_id, file_type)
    FileAsset::store_file(dir, filename, bytes)
    filename
  end
  
  def self.store_file(dir, filename, bytes)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)    
    File.open(dir + '/' + filename, 'wb').write(bytes) if File.directory?(dir)        
  end
  
  def self.store_for_type(author, file_info, bytes, type)    
    filename = generate_new_filename(file_info.original_filename)        
    dir = dir_for_author(author.id, type)
    store_file(dir, filename, bytes)    
    filename    
  end
  
end
