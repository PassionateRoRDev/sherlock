def dst_dir
    "#{Rails.root}/#{APP_CONFIG['files_path']}"    
end

def prepare_files_dir    
  FileUtils.rm_rf(dst_dir)
  FileUtils.mkdir_p(dst_dir)        
end

def fixture_file_path(filename)
  "#{Rails.root}/features/fixtures/files/#{filename}"
end

def copy_fixture_file(filename)              
  result_path = File.join(dst_dir, filename)
  FileUtils.copy(fixture_file_path(filename), result_path)  
  result_path
end