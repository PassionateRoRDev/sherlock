
config = YAML.load_file(File.join Rails.root, 'config', 'config.yml')
chargify_config = config['application']['chargify']
Chargify.configure do |c|
    c.subdomain = chargify_config['subdomain']
    c.api_key = chargify_config['api_key']
end