module Pesapal
    
    class Merchant

        attr_accessor :callback_url, :credentials, :order_details
        attr_reader :api_domain, :api_endpoints

        def api_domain
            @api_domain
        end

        def api_endpoints
            @api_endpoints
        end

        def callback_url
            @callback_url
        end

        def credentials
            @credentials
        end

        def order_details
            @order_details
        end

        private

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
            def initialize(mode = :development)

                # convert symbol to string and downcase
                mode.to_s.downcase!

                # initialize
                @params = nil
                @post_xml = nil
                @token_secret = nil

                # set the credentials from the config (if initializers/pesapal.rb
                # exists they should have set these values)
                @credentials = nil

                # set the callback url that the iframe will respond to
                @callback_url = 'http://0.0.0.0:3000/pesapal/callback'

                # set api endpoints depending on the mode
                @api_endpoints = {}
                if mode == 'development'
                    set_endpoints_development
                elseif mode == 'production'
                    set_endpoints_production
                else
                    set_endpoints_development
                end
            end

            # generate pesapal order url (often iframed)
            def generate_order_url

                # build xml with input data, the format is standard so no editing is
                # required
                @post_xml = Pesapal::Post::generate_post_xml @order_details

                # initialize setting of @params (oauth_signature left empty) ... this gene
                @params = Pesapal::Post::set_parameters(@callback_url, @credentials[:consumer_key], @post_xml)

                # generate oauth signature and add signature to the request parameters
                @params[:oauth_signature] = Pesapal::Oauth::generate_oauth_signature("GET", @api_endpoints[:postpesapaldirectorderv4], @params, @credentials[:consumer_secret], @token_secret)

                # change params (with signature) to a query string
                query_string = Pesapal::Oauth::generate_encoded_params_query_string @params

                "#{@api_endpoints[:postpesapaldirectorderv4]}?#{query_string}"
            end

        private

            # set all endpoint for use in development mode
            def set_endpoints_development
                @api_domain = 'http://demo.pesapal.com'
                set_endpoints @api_domain
            end

            # set all enpoints for use in production mode
            def set_endpoints_production
                @api_domain = "https://www.pesapal.com"
                set_endpoints @api_domain
            end

            # set endpoints
            def set_endpoints(domain_string)
                @api_endpoints[:postpesapaldirectorderv4] = "#{domain_string}/API/PostPesapalDirectOrderV4"
                @api_endpoints[:querypaymentstatus] = "#{domain_string}/API/QueryPaymentStatus"
                @api_endpoints[:querypaymentstatusbymerchantref] = "#{domain_string}/API/QueryPaymentStatus"
                @api_endpoints[:querypaymentdetails] = "#{domain_string}/API/QueryPaymentDetails"
            end
    end
end
