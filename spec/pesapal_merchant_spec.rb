require 'spec_helper'

describe Pesapal::Merchant do

  before :each do
    @pesapal = Pesapal::Merchant.new
    @pesapal_dev = Pesapal::Merchant.new(:development)
    @pesapal_prod = Pesapal::Merchant.new(:production)
  end

  describe '#new' do

    it 'sets default environment variable' do
      @pesapal.send(:env).should == 'development'
      @pesapal.send(:env).should_not == 'production'
    end

    it 'sets development environment variable' do
      @pesapal_dev.send(:env).should == 'development'
      @pesapal_dev.send(:env).should_not == 'production'
    end

    it 'sets production environment variable' do
      @pesapal_prod.send(:env).should == 'production'
      @pesapal_prod.send(:env).should_not == 'development'
    end

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
