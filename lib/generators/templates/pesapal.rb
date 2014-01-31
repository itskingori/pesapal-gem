# Load Pesapal config file from YAML file when application is loaded
Pesapal.config = YAML::load(IO.read("#{Rails.root}/config/pesapal.yml"))