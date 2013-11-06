module Pesapal

  module Post

    # build html encoded xml string for PostPesapalDirectOrderV4
    def Post.generate_post_xml(details)

      # build xml with input data, the format is standard so no editing is
      # required
      post_xml = ''
      post_xml.concat '<?xml version="1.0" encoding="utf-8"?>'
      post_xml.concat '<PesapalDirectOrderInfo '
      post_xml.concat 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
      post_xml.concat 'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
      post_xml.concat "Amount=\"#{details[:amount]}\" "
      post_xml.concat "Description=\"#{details[:description]}\" "
      post_xml.concat "Type=\"#{details[:type]}\" "
      post_xml.concat "Reference=\"#{details[:reference]}\" "
      post_xml.concat "FirstName=\"#{details[:first_name]}\" "
      post_xml.concat "LastName=\"#{details[:last_name]}\" "
      post_xml.concat "Email=\"#{details[:email]}\" "
      post_xml.concat "PhoneNumber=\"#{details[:phonenumber]}\" "
      post_xml.concat "Currency=\"#{details[:currency]}\" "
      post_xml.concat 'xmlns="http://www.pesapal.com" />'

      encoder = HTMLEntities.new(:xhtml1)
      post_xml = encoder.encode post_xml

      "#{post_xml}"
    end

    # set parameters required by the PostPesapalDirectOrderV4 call
    def Post.set_parameters(callback_url, consumer_key, post_xml)

      # parameters required by the PostPesapalDirectOrderV4 call (excludes
      # oauth_signature parameter as per the instructions here
      # http://developer.pesapal.com/how-to-integrate/api-reference#PostPesapalDirectOrderV4)

      timestamp = Time.now.to_i.to_s

      params = { :oauth_callback => callback_url,
                 :oauth_consumer_key => consumer_key,
                 :oauth_nonce => "#{timestamp}" + Pesapal::Oauth.generate_nonce(12),
                 :oauth_signature_method => 'HMAC-SHA1',
                 :oauth_timestamp => "#{timestamp}",
                 :oauth_version => '1.0',
                 :pesapal_request_data => post_xml
              }
    end
  end
end
