After do |scenario|
  # remove temporary files created during the tests:
  FileUtils.rm_rf(APP_CONFIG['files_path'])
end