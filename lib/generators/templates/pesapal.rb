# Load Pesapal config file when applicatin is loaded ... the config can then be
# accessed from PesapalRails::Application.config.yaml
module PesapalRails
    class Application < Rails::Application
        config.yaml = YAML::load(IO.read("#{Rails.root}/config/pesapal.yml"))
    end
end
