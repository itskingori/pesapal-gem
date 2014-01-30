module Pesapal

  class Railtie < Rails::Railtie

    initializer 'pesapal.load_credentials' do

      path_to_yaml = "#{Rails.root}/config/pesapal.yml"
      if File.exist?(path_to_yaml)
        begin
          config.pesapal_credentials = YAML::load(IO.read(path_to_yaml))[Rails.env]
        rescue Errno::ENOENT
          logger.info('YAML configuration file couldn\'t be found. Using defaults.'); return
        rescue Psych::SyntaxError
          logger.info('YAML configuration file contains invalid syntax. Will use using defaults.'); return
        end
      end
    end
  end
end
