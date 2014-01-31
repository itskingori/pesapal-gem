require 'spec_helper'

describe Pesapal::Merchant do

  before :each do
    @pesapal = Pesapal::Merchant.new
  end

  describe '#new' do

    # Check if the initializer successfully sets a Pesapal::Merchant object
    it 'returns a new instance of a pesapal object' do
      @pesapal.should be_an_instance_of Pesapal::Merchant
    end

    # Checks if the initialized object is properly set with default credentials
    it 'checks if config is set with the default credentials' do
      @pesapal.config.should == { :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                  :consumer_key => '<YOUR_CONSUMER_KEY>',
                                  :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                }
    end

    # Checks if the initialized object is properly set with empty order details
    it 'checks if config is set with the default credentials' do
      @pesapal.order_details.should == {}
    end
  end
end
