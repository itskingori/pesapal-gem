# Load Pesapal config file from YAML file when applicatin is loaded
Pesapal.config = YAML::load(IO.read("#{Rails.root}/config/pesapal.yml"))
