module Pesapal
  module Status
    # set parameters required by the QueryPaymentStatus & QueryPaymentStatusByMerchantRef calls
    def self.set_parameters(consumer_key, merchant_reference, transaction_tracking_id = nil)

      # parameters required by the QueryPaymentStatus call (excludes
      # oauth_signature parameter as per the instructions here
      # http://developer.pesapal.com/how-to-integrate/api-reference)

      timestamp = Time.now.to_i.to_s

      params = { :oauth_consumer_key => consumer_key,
                 :oauth_nonce => "#{timestamp}" + Pesapal::Oauth.generate_nonce(12),
                 :oauth_signature_method => 'HMAC-SHA1',
                 :oauth_timestamp => "#{timestamp}",
                 :oauth_version => '1.0',
                 :pesapal_merchant_reference => merchant_reference
              }

      unless transaction_tracking_id.nil? # do, if not true
        params[:pesapal_transaction_tracking_id] = transaction_tracking_id
      end

      params
    end
  end
end
