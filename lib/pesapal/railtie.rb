module Pesapal

  class Railtie < Rails::Railtie

    initializer 'pesapal.load_credentials' do

      path_to_yaml = "#{Rails.root}/config/pesapal.yml"
      if File.exist?(path_to_yaml)
        begin
          config.pesapal_credentials = YAML::load(IO.read(path_to_yaml))[Rails.env]
        rescue Errno::ENOENT
          logger.info('YAML configuration file couldn\'t be found.'); return
        rescue Psych::SyntaxError
          logger.info('YAML configuration file contains invalid syntax. Will use using defaults.'); return
        end
      else
        config.pesapal_credentials = { :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                       :consumer_key => '<YOUR_CONSUMER_KEY>',
                                       :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                      }
      end
    end
  end
end
