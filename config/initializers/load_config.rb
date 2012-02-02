config = YAML.load_file("#{Rails.root}/config/config.yml")

app_config = config['application']
env_config = config[Rails.env]

APP_CONFIG = app_config.merge(env_config)

