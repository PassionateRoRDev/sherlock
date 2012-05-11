
config = YAML.load_file(File.join Rails.root, 'config', 'config.yml')
km_config = (config['application'].merge(config[Rails.env]))['km']
km_log_dir = File.join(Rails.root, 'log', 'km')
FileUtils.mkdir_p km_log_dir unless File.exists? km_log_dir
KM.init km_config['api_key'], :log_dir => km_log_dir
