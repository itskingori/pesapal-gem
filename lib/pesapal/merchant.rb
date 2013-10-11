module Pesapal
    
    class Merchant

        attr_accessor :config, :order_details
        attr_reader :api_domain, :api_endpoints

        def api_domain
            @api_domain
        end

        def api_endpoints
            @api_endpoints
        end

        def config
            @config
        end

        def order_details
            @order_details
        end

        private

            def mode
                @mode
            end

            def params
                @params
            end

            def post_xml
                @post_xml
            end

            def token_secret
                @token_secret
            end

        public

            # constructor
            def initialize(mode = :development, path_to_file = "#{Rails.root}/config/pesapal.yml")

                # initialize
                @params = nil
                @post_xml = nil
                @token_secret = nil

                # convert symbol to string and downcase
                @mode = "#{mode.to_s.downcase}"

                # set the credentials
                set_configuration_from_yaml path_to_file

                # set api endpoints depending on the mode
                set_endpoints
            end

            # generate pesapal order url (often iframed)
            def generate_order_url

                # build xml with input data, the format is standard so no editing is
                # required
                @post_xml = Pesapal::Post::generate_post_xml @order_details

                # initialize setting of @params (oauth_signature left empty) ... this gene
                @params = Pesapal::Post::set_parameters(@config[:callback_url], @config[:consumer_key], @post_xml)

                # generate oauth signature and add signature to the request parameters
                @params[:oauth_signature] = Pesapal::Oauth::generate_oauth_signature("GET", @api_endpoints[:postpesapaldirectorderv4], @params, @config[:consumer_secret], @token_secret)

                # change params (with signature) to a query string
                query_string = Pesapal::Oauth::generate_encoded_params_query_string @params

                "#{@api_endpoints[:postpesapaldirectorderv4]}?#{query_string}"
            end

        private

            # set endpoints
            def set_endpoints

                if @mode == 'production'
                    @api_domain = 'https://www.pesapal.com'
                else
                    @api_domain = 'http://demo.pesapal.com'
                end

                @api_endpoints = {}
                @api_endpoints[:postpesapaldirectorderv4] = "#{@api_domain}/API/PostPesapalDirectOrderV4"
                @api_endpoints[:querypaymentstatus] = "#{@api_domain}/API/QueryPaymentStatus"
                @api_endpoints[:querypaymentstatusbymerchantref] = "#{@api_domain}/API/QueryPaymentStatus"
                @api_endpoints[:querypaymentdetails] = "#{@api_domain}/API/QueryPaymentDetails"
            end

            # set credentialts through hash, uses default if nothing is input
            def set_configuration(consumer_details = {})

                # set the configuration
                @config = { :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                            :consumer_key => '<YOUR_CONSUMER_KEY>',
                            :consumer_secret => '<YOUR_CONSUMER_SECRET>' 
                        }

                valid_config_keys = @config.keys

                consumer_details.each { |k,v| @config[k.to_sym] = v if valid_config_keys.include? k.to_sym }
            end

            # set configuration through yaml file
            def set_configuration_from_yaml(path_to_file)

                if File.exist?(path_to_file)

                    # load file, read it and parse the YAML
                    begin
                        loaded_config = YAML::load(IO.read(path_to_file))
                    rescue Errno::ENOENT
                        logger.info("YAML configuration file couldn't be found. Using defaults."); return
                    rescue Psych::SyntaxError
                        logger.info("YAML configuration file contains invalid syntax. Using defaults."); return
                    end

                    # pick the correct settings depending on the the mode and
                    # set it appropriately. this file is expected to have the
                    # settings for development and production
                    set_configuration loaded_config[@mode]

                else

                    # in this case default values will be set
                    set_configuration
                end 
            end
    end
end
