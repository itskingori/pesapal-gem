require "pesapal/version"

module Pesapal
    
    class Pesapal

        require 'htmlentities'

        attr_accessor :callback_url, :credentials
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
            def order_url

                # define the inputs
                details = {}
                details[:amount] = 1000
                details[:description] = 'this is the transaction description'
                details[:type] = 'MERCHANT'
                details[:reference] = 808
                details[:first_name] = 'Swaleh'
                details[:last_name] = 'Mdoe'
                details[:email] = 'j@kingori.co'
                details[:phonenumber] = ''

                # build xml with input data, the format is standard so no editing is
                # required
                @post_xml = ''
                @post_xml.concat '<?xml version="1.0" encoding="utf-8"?>'
                @post_xml.concat '<PesapalDirectOrderInfo '
                @post_xml.concat 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
                @post_xml.concat 'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
                @post_xml.concat "Amount=\"#{details[:amount]}\" "
                @post_xml.concat "Description=\"#{details[:description]}\" "
                @post_xml.concat "Type=\"#{details[:type]}\" "
                @post_xml.concat "Reference=\"#{details[:reference]}\" "
                @post_xml.concat "FirstName=\"#{details[:first_name]}\" "
                @post_xml.concat "LastName=\"#{details[:last_name]}\" "
                @post_xml.concat "Email=\"#{details[:email]}\" "
                @post_xml.concat "PhoneNumber=\"#{details[:phonenumber]}\" "
                @post_xml.concat 'xmlns="http://www.pesapal.com" />'

                # html encode built xml
                encoder = HTMLEntities.new(:xhtml1)
                @post_xml = encoder.encode @post_xml

                # initialize setting of @params (oauth_signature left empty)
                set_parameters

                # add signature to the params
                @params[:oauth_signature] = generate_oauth_signature

                # change params (with signature) to a query string
                query_string = generate_params_query_string

                "#{@api_endpoints[:postpesapaldirectorderv4]}?#{query_string}"
            end

        private

            # generate nonce
            def generate_nonce(length)
                chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
                nonce = ''
                length.times { nonce << chars[rand(chars.size)] }
                nonce
            end

            # set parameters (includes an empty oauth_signature)
            def set_parameters

                timestamp = Time.now.to_i.to_s

                @params = { :oauth_callback => @callback_url,
                            :oauth_consumer_key => @credentials[:consumer_key],
                            :oauth_nonce => "#{timestamp}#{generate_nonce(12)}",
                            :oauth_signature_method => 'HMAC-SHA1',
                            :oauth_timestamp => "#{timestamp}",
                            :oauth_version => '1.0',
                            :pesapal_request_data => @post_xml
                        }
            end

            # generate signable parameters
            def generate_signable_parameters

                # oauth_signature parameter MUST be excluded, assumes it was already
                # initialized by calling set_parameters
                @params.delete(:oauth_signature)

                generate_params_query_string
            end

            # generate query string from @params
            def generate_params_query_string

                # 1) percent encode every key and value that will be signed
                # 2) sort the list of parameters alphabetically by encoded key
                # 3) for each key/value pair
                # - append the encoded key to the output string
                # - append the '=' character to the output string
                # - append the encoded value to the output string
                # 4) if there are more key/value pairs remaining, append a '&' character
                # to the output string

                #  the OAuth spec says to sort lexigraphically, which is the default
                #  alphabetical sort for many libraries. in case of two parameters with
                #  the same encoded key, the OAuth spec says to continue sorting based
                #  on value

                queries = []
                @params.each do |k,v| queries.push "#{parameter_encode(k.to_s)}=#{parameter_encode(v.to_s)}" end

                # parameters are sorted by name, using lexicographical byte value
                # ordering
                queries.sort!
                
                queries.join('&')
            end

            # generate oauth signature
            def generate_signature_base_string(http_method = "GET")

                #  three values collected so far must be joined to make a single string,
                #  from which the signature will be generated. This is called the
                #  signature base string by the OAuth specification

                # step 1: convert the http method to uppercase
                http_method = http_method.upcase

                # step 2: percent encode the url
                url_encoded = parameter_encode(normalized_uri(@api_endpoints[:postpesapaldirectorderv4]))

                # step 3: percent encode the parameter string
                parameter_string_encoded = parameter_encode(generate_signable_parameters)

                # the signature base string should contain exactly 2 ampersand '&'
                # characters. The percent '%' characters in the parameter string should
                # be encoded as %25 in the signature base string

                "#{http_method}&#{url_encoded}&#{parameter_string_encoded}"
            end

            # generate signing key
            def generate_signing_key

                # the signing key is simply the percent encoded consumer secret,
                # followed by an ampersand character '&', followed by the percent
                # encoded token secret

                # note that there are some flows, such as when obtaining a request
                # token, where the token secret is not yet known. In this case, the
                # signing key should consist of the percent encoded consumer secret
                # followed by an ampersand character '&'

                # "#{@credentials[:consumer_secret]}"
                consumer_secret_encoded = parameter_encode(@credentials[:consumer_secret])

                token_secret_encoded = ""
                unless @token_secret.nil?
                    token_secret_encoded = parameter_encode(@token_secret)
                end

                "#{consumer_secret_encoded}&#{token_secret_encoded}"
            end

            # generate oauth signature
            def generate_oauth_signature

                # the signature is calculated by passing the signature base string and
                # signing key to the HMAC-SHA1 hashing algorithm. the output of the HMAC
                # signing function is a binary string. This needs to be base64 encoded
                # to produce the signature string.
                
                digest = OpenSSL::Digest::Digest.new('sha1')
                hmac = OpenSSL::HMAC.digest(digest, generate_signing_key, generate_signature_base_string)
                Base64.encode64(hmac).chomp
            end

            # normalize input URI
            def normalized_uri(uri)

                # the signature base string includes the request absolute url, tying the
                # signature to a specific endpoint. the url used in the signature base
                # string must include the scheme, authority, and path, and must exclude
                # the query and fragment as defined by [rfc3986] section 3.

                # if the absolute request url is not available to the service provider
                # (it is always available to the consumer), it can be constructed by
                # combining the scheme being used, the http host header, and the
                # relative http request url. if the host header is not available, the
                # service provider should use the host name communicated to the consumer
                # in the documentation or other means.

                # the service provider should document the form of url used in the
                # signature base string to avoid ambiguity due to url normalization.
                # unless specified, url scheme and authority must be lowercase and
                # include the port number; http default port 80 and https default port
                # 443 must be excluded.
              
                u = URI.parse(uri)

                scheme = u.scheme.downcase
                host = u.host.downcase
                path = u.path
                port = u.port

                port = (scheme == 'http' && port != 80) || (scheme == 'https' && port != 443) ? ":#{port}" : ""
                path = (path && path != '') ? path : '/'

                "#{scheme}://#{host}#{port}#{path}"
            end

            # percentage encode
            def parameter_encode(string)

                # all parameter names and values are escaped using the [rfc3986]
                # percent-encoding (%xx) mechanism. characters not in the unreserved
                # character set ([rfc3986] section 2.3) must be encoded. characters in
                # the unreserved character set must not be encoded. hexadecimal
                # characters in encodings must be upper case. text names and values must
                # be encoded as utf-8 octets before percent-encoding them per [rfc3629].

                # reserved character regexp, per section 5.1
                reserved_characters = /[^a-zA-Z0-9\-\.\_\~]/

                URI::escape(string.to_s.force_encoding(Encoding::UTF_8), reserved_characters)
            end

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
