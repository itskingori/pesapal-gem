module Pesapal
  module Oauth
    # generate query string from parameters hash
    def self.generate_encoded_params_query_string(params = {})

      # 1) percent encode every key and value that will be signed
      # 2) sort the list of parameters alphabetically by encoded key
      # 3) for each key/value pair
      # - append the encoded key to the output string
      # - append the '=' character to the output string
      # - append the encoded value to the output string
      # 4) if there are more key/value pairs remaining, append a '&' character
      # to the output string

      #  the oauth spec says to sort lexigraphically, which is the default
      #  alphabetical sort for many libraries. in case of two parameters with
      #  the same encoded key, the oauth spec says to continue sorting based on
      #  value

      queries = []
      params.each { |k,v| queries.push "#{self.parameter_encode(k.to_s)}=#{self.parameter_encode(v.to_s)}" }

      # parameters are sorted by name, using lexicographical byte value
      # ordering
      queries.sort!

      queries.join('&')
    end

    # generate oauth nonce
    def self.generate_nonce(length)

      # the consumer shall then generate a nonce value that is unique for all
      # requests with that timestamp. a nonce is a random string, uniquely
      # generated for each request. the nonce allows the service provider to
      # verify that a request has never been made before and helps prevent
      # replay attacks when requests are made over a non- secure channel (such
      # as http).

      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
      nonce = ''
      length.times { nonce << chars[rand(chars.size)] }

      "#{nonce}"
    end

    # generate the oauth signature using hmac-sha1 algorithm
    def self.generate_oauth_signature(http_method, absolute_url, params, consumer_secret, token_secret = nil)

      # the signature is calculated by passing the signature base string and
      # signing key to the hmac-sha1 hashing algorithm. the output of the hmac
      # signing function is a binary string. this needs to be base64 encoded to
      # produce the signature string.

      # for pesapal flow we don't have a token secret to we will set as nil and
      # the appropriate action will be taken as per the oauth spec. see notes in
      # the method that creates signing keys

      # prepare the values we need
      digest = OpenSSL::Digest::Digest.new('sha1')
      signature_base_string = self.generate_signature_base_string(http_method, absolute_url, params)
      signing_key = self.generate_signing_key(consumer_secret, token_secret)

      hmac = OpenSSL::HMAC.digest(digest, signing_key, signature_base_string)
      Base64.encode64(hmac).chomp
    end

    # generate query string from signable parameters hash
    def self.generate_signable_encoded_params_query_string(params = {})

      # oauth_signature parameter MUST be excluded, assumes it was already
      # initialized by calling set_parameters
      params.delete(:oauth_signature)

      self.generate_encoded_params_query_string params
    end

    # generate the oauth signature
    def self.generate_signature_base_string(http_method, absolute_url, params)

      #  three values collected so far must be joined to make a single string,
      #  from which the signature will be generated. This is called the
      #  signature base string by the OAuth specification

      # step 1: convert the http method to uppercase
      http_method = http_method.upcase

      # step 2: percent encode the url
      url_encoded = self.parameter_encode(self.normalized_request_uri(absolute_url))

      # step 3: percent encode the parameter string
      parameter_string_encoded = self.parameter_encode(self.generate_signable_encoded_params_query_string params)

      # the signature base string should contain exactly 2 ampersand '&'
      # characters. The percent '%' characters in the parameter string should be
      # encoded as %25 in the signature base string

      "#{http_method}&#{url_encoded}&#{parameter_string_encoded}"
    end

    # generate signing key
    def self.generate_signing_key(consumer_secret, token_secret = nil)

      # the signing key is simply the percent encoded consumer secret, followed
      # by an ampersand character '&', followed by the percent encoded token
      # secret

      # note that there are some flows, such as when obtaining a request token,
      # where the token secret is not yet known. In this case, the signing key
      # should consist of the percent encoded consumer secret followed by an
      # ampersand character '&'

      # "#{@credentials[:consumer_secret]}"
      consumer_secret_encoded = self.parameter_encode(consumer_secret)

      token_secret_encoded = ""
      unless token_secret.nil?
        token_secret_encoded = self.parameter_encode(token_secret)
      end

      "#{consumer_secret_encoded}&#{token_secret_encoded}"
    end

    # normalize request absolute URL
    def self.normalized_request_uri(absolute_url)

      # the signature base string includes the request absolute url, tying the
      # signature to a specific endpoint. the url used in the signature base
      # string must include the scheme, authority, and path, and must exclude
      # the query and fragment as defined by [rfc3986] section 3.

      # if the absolute request url is not available to the service provider (it
      # is always available to the consumer), it can be constructed by combining
      # the scheme being used, the http host header, and the relative http
      # request url. if the host header is not available, the service provider
      # should use the host name communicated to the consumer in the
      # documentation or other means.

      # the service provider should document the form of url used in the
      # signature base string to avoid ambiguity due to url normalization.
      # unless specified, url scheme and authority must be lowercase and include
      # the port number; http default port 80 and https default port 443 must be
      # excluded.

      u = URI.parse(absolute_url)

      scheme = u.scheme.downcase
      host = u.host.downcase
      path = u.path
      port = u.port

      port = (scheme == 'http' && port != 80) || (scheme == 'https' && port != 443) ? ":#{port}" : ""
      path = (path && path != '') ? path : '/'

      "#{scheme}://#{host}#{port}#{path}"
    end

    # percentage encode value as per the oauth spec
    def self.parameter_encode(string)

      # all parameter names and values are escaped using the [rfc3986] percent-
      # encoding (%xx) mechanism. characters not in the unreserved character set
      # ([rfc3986] section 2.3) must be encoded. characters in the unreserved
      # character set must not be encoded. hexadecimal characters in encodings
      # must be upper case. text names and values must be encoded as utf-8
      # octets before percent-encoding them per [rfc3629].

      # reserved character regexp, per section 5.1
      reserved_characters = /[^a-zA-Z0-9\-\.\_\~]/

      # Apparently we can't force_encoding on a frozen string since that would modify it.
      # What we can do is work with a copy
      URI::escape(string.dup.to_s.force_encoding(Encoding::UTF_8), reserved_characters)
    end
  end
end
