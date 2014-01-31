module Pesapal

  module Details

    # set parameters required by the QueryPaymentDetails call
    def self.set_parameters(consumer_key, merchant_reference, transaction_tracking_id)

      # parameters required by the QueryPaymentDetails call (excludes
      # oauth_signature parameter as per the instructions here
      # http://developer.pesapal.com/how-to-integrate/api-reference#QueryPaymentDetails)

      timestamp = Time.now.to_i.to_s

      params = { :oauth_consumer_key => consumer_key,
                 :oauth_nonce => "#{timestamp}" + Pesapal::Oauth.generate_nonce(12),
                 :oauth_signature_method => 'HMAC-SHA1',
                 :oauth_timestamp => "#{timestamp}",
                 :oauth_version => '1.0',
                 :pesapal_merchant_reference => merchant_reference,
                 :pesapal_transaction_tracking_id => transaction_tracking_id
              }
    end
  end
end
