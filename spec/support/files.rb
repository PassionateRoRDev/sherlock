def dst_dir
    "#{Rails.root}/#{APP_CONFIG['files_path']}"    
end

def prepare_files_dir    
  FileUtils.rm_rf(dst_dir)
  FileUtils.mkdir_p(dst_dir)        
end

def copy_fixture_file(filename)            
  src_image = "#{Rails.root}/features/fixtures/files/#{filename}"   
  result_path = File.join(dst_dir, filename)
  FileUtils.copy(src_image, result_path)  
  result_path
end