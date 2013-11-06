module Pesapal

    class Merchant

        attr_accessor :config, :order_details

        def config
            @config
        end

        def order_details
            @order_details
        end

        private

            def api_domain
                @api_domain
            end

            def api_endpoints
                @api_endpoints
            end

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
            def initialize(mode = :development, path_to_file = nil)

                # initialize
                @params = nil
                @post_xml = nil
                @token_secret = nil

                set_mode mode

                # set the credentials if we have not set a custom path for the YAML config file
                if path_to_file.nil?
                    # no path to file so no YAML override so we load from initializer
                    set_configuration PesapalRails::Application.config.yaml[@mode]
                else
                    # we have custom path so we load from file
                    set_configuration_from_yaml path_to_file
                end

            end

            # generate pesapal order url (often iframed)
            def generate_order_url

                # build xml with input data, the format is standard so no editing is
                # required
                @post_xml = Pesapal::Post::generate_post_xml @order_details

                # initialize setting of @params (oauth_signature left empty)
                @params = Pesapal::Post::set_parameters(@config[:callback_url], @config[:consumer_key], @post_xml)

                # generate oauth signature and add signature to the request parameters
                @params[:oauth_signature] = Pesapal::Oauth::generate_oauth_signature("GET", @api_endpoints[:postpesapaldirectorderv4], @params, @config[:consumer_secret], @token_secret)

                # change params (with signature) to a query string
                query_string = Pesapal::Oauth::generate_encoded_params_query_string @params

                "#{@api_endpoints[:postpesapaldirectorderv4]}?#{query_string}"
            end

            # query the details of the transaction
            def query_payment_details(merchant_reference, transaction_tracking_id)

                # initialize setting of @params (oauth_signature left empty)
                @params = Pesapal::Details::set_parameters(@config[:consumer_key], merchant_reference, transaction_tracking_id)

                # generate oauth signature and add signature to the request parameters
                @params[:oauth_signature] = Pesapal::Oauth::generate_oauth_signature("GET", @api_endpoints[:querypaymentdetails], @params, @config[:consumer_secret], @token_secret)

                # change params (with signature) to a query string
                query_string = Pesapal::Oauth::generate_encoded_params_query_string @params

                # get status response
                response = Net::HTTP.get(URI("#{@api_endpoints[:querypaymentdetails]}?#{query_string}"))
                response = CGI::parse(response)
                response = response["pesapal_response_data"][0].split(',')

                details = { :method => response[1],
                            :status => response[2],
                            :merchant_reference => response[3],
                            :transaction_tracking_id => response[0] }
            end

            # query the status of the transaction
            def query_payment_status(merchant_reference, transaction_tracking_id = nil)

                # initialize setting of @params (oauth_signature left empty)
                @params = Pesapal::Status::set_parameters(@config[:consumer_key], merchant_reference, transaction_tracking_id)

                # generate oauth signature and add signature to the request parameters
                @params[:oauth_signature] = Pesapal::Oauth::generate_oauth_signature("GET", @api_endpoints[:querypaymentstatus], @params, @config[:consumer_secret], @token_secret)

                # change params (with signature) to a query string
                query_string = Pesapal::Oauth::generate_encoded_params_query_string @params

                # get status response
                response = Net::HTTP.get(URI("#{@api_endpoints[:querypaymentstatus]}?#{query_string}"))
                response = CGI::parse(response)

                # return the string result of what we want
                response["pesapal_response_data"][0]
            end

            # set mode when called
            def set_mode(mode = :development)

                # convert symbol to string and downcase
                @mode = "#{mode.to_s.downcase}"

                # set api endpoints depending on the mode
                set_endpoints
            end

            # listen to ipn response
            def ipn_listener(notification_type, merchant_reference, transaction_tracking_id)

                status = query_payment_status(merchant_reference, transaction_tracking_id)

                output = { :status => status }

                if status == "COMPLETED"
                    output[:response] = "pesapal_notification_type=CHANGE&pesapal_transaction_tracking_id=#{transaction_tracking_id}&pesapal_merchant_reference=#{merchant_reference}"
                elsif status == "FAILED"
                    output[:response] = "pesapal_notification_type=CHANGE&pesapal_transaction_tracking_id=#{transaction_tracking_id}&pesapal_merchant_reference=#{merchant_reference}"
                else
                    output[:response] = ""
                end

                output
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
