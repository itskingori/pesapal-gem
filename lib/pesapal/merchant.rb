module Pesapal
  class Merchant
    attr_accessor :config, :order_details

    def config
      @config ||= {}
    end

    def order_details
      @order_details ||= {}
    end

    private

    attr_reader :api_domain, :api_endpoints, :env

    def params
      @params ||= nil
    end

    def post_xml
      @post_xml ||= nil
    end

    def token_secret
      @token_secret ||= nil
    end

    public

    # constructor
    def initialize(env = false)
      set_env env
      if defined?(Rails)
        set_configuration Rails.application.config.pesapal_credentials
      else
        set_configuration
      end
    end

    # generate pesapal order url (often iframed)
    def generate_order_url

      # build xml with input data, the format is standard so no editing is
      # required
      @post_xml = Pesapal::Post.generate_post_xml @order_details

      # initialize setting of @params (oauth_signature left empty)
      @params = Pesapal::Post.set_parameters(@config[:callback_url], @config[:consumer_key], @post_xml)

      # generate oauth signature and add signature to the request parameters
      @params[:oauth_signature] = Pesapal::Oauth::generate_oauth_signature("GET", @api_endpoints[:postpesapaldirectorderv4], @params, @config[:consumer_secret], @token_secret)

      # change params (with signature) to a query string
      query_string = Pesapal::Oauth.generate_encoded_params_query_string @params

      "#{@api_endpoints[:postpesapaldirectorderv4]}?#{query_string}"
    end

    # query the details of the transaction
    def query_payment_details(merchant_reference, transaction_tracking_id)

      # initialize setting of @params (oauth_signature left empty)
      @params = Pesapal::Details.set_parameters(@config[:consumer_key], merchant_reference, transaction_tracking_id)

      # generate oauth signature and add signature to the request parameters
      @params[:oauth_signature] = Pesapal::Oauth.generate_oauth_signature("GET", @api_endpoints[:querypaymentdetails], @params, @config[:consumer_secret], @token_secret)

      # change params (with signature) to a query string
      query_string = Pesapal::Oauth.generate_encoded_params_query_string @params

      # get status response
      uri = URI.parse "#{@api_endpoints[:querypaymentstatus]}?#{query_string}"
      http = Net::HTTP.new(uri.host, uri.port)
      if @env == 'production'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      response = CGI.parse response.body
      response = response['pesapal_response_data'][0].split(',')

      { :method => response[1],
        :status => response[2],
        :merchant_reference => response[3],
        :transaction_tracking_id => response[0]
      }
    end

    # query the status of the transaction
    def query_payment_status(merchant_reference, transaction_tracking_id = nil)

      # initialize setting of @params (oauth_signature left empty)
      @params = Pesapal::Status.set_parameters(@config[:consumer_key], merchant_reference, transaction_tracking_id)

      # generate oauth signature and add signature to the request parameters
      @params[:oauth_signature] = Pesapal::Oauth.generate_oauth_signature("GET", @api_endpoints[:querypaymentstatus], @params, @config[:consumer_secret], @token_secret)

      # change params (with signature) to a query string
      query_string = Pesapal::Oauth.generate_encoded_params_query_string @params

      # get status response
      uri = URI.parse "#{@api_endpoints[:querypaymentstatus]}?#{query_string}"
      http = Net::HTTP.new(uri.host, uri.port)
      if @env == 'production'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      response = CGI.parse response.body
      response['pesapal_response_data'][0]
    end

    # set env when called
    def set_env(env = false)
      env = env.to_s.downcase
      if env == 'production'
        @env = 'production'
      else
        @env = 'development'
        @env = Rails.env if defined?(Rails)
      end
      set_endpoints
    end

    # listen to ipn response
    def ipn_listener(notification_type, merchant_reference, transaction_tracking_id)
      status = query_payment_status(merchant_reference, transaction_tracking_id)
      output = { :status => status, :response => nil }

      case status
      when 'COMPLETED' then output[:response] = "pesapal_notification_type=CHANGE&pesapal_transaction_tracking_id=#{transaction_tracking_id}&pesapal_merchant_reference=#{merchant_reference}"
      when 'FAILED'    then output[:response] = "pesapal_notification_type=CHANGE&pesapal_transaction_tracking_id=#{transaction_tracking_id}&pesapal_merchant_reference=#{merchant_reference}"
      end

      output
    end

    private

    # set endpoints
    def set_endpoints
      if @env == 'production'
        @api_domain = 'https://www.pesapal.com'
      else
        @api_domain = 'http://demo.pesapal.com'
      end

      @api_endpoints = {}
      @api_endpoints[:postpesapaldirectorderv4] = "#{@api_domain}/API/PostPesapalDirectOrderV4"
      @api_endpoints[:querypaymentstatus] = "#{@api_domain}/API/QueryPaymentStatus"
      @api_endpoints[:querypaymentdetails] = "#{@api_domain}/API/QueryPaymentDetails"

      @api_endpoints
    end

    # set credentialts through hash, uses default if nothing is input
    def set_configuration(consumer_details = {})
      # set the configuration
      @config = { :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                  :consumer_key => '<YOUR_CONSUMER_KEY>',
                  :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                }

      valid_config_keys = @config.keys

      consumer_details.each { |k, v| @config[k.to_sym] = v if valid_config_keys.include? k.to_sym }
    end
  end
end
