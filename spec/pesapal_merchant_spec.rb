require 'spec_helper'

describe Pesapal::Merchant do

  describe '#new' do

    context 'when mode not specified' do

      before :each do
        @pesapal = Pesapal::Merchant.new
      end

      it 'valid new object' do
        @pesapal.should be_an_instance_of Pesapal::Merchant
      end

      it 'sets default environment variable' do
        @pesapal.send(:env).should == 'development'
      end

      it 'config set with the default credentials' do
        @pesapal.config.should == { :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                    :consumer_key => '<YOUR_CONSUMER_KEY>',
                                    :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                  }
      end

      it 'empty default order details' do
        @pesapal.order_details.should == {}
      end
    end

    context 'when mode specified as development' do

      before :each do
        @pesapal_dev = Pesapal::Merchant.new(:development)
      end

      it 'valid new object' do
        @pesapal_dev.should be_an_instance_of Pesapal::Merchant
      end

      it 'sets default environment variable' do
        @pesapal_dev.send(:env).should == 'development'
      end

      it 'config set with the default credentials' do
        @pesapal_dev.config.should == { :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                        :consumer_key => '<YOUR_CONSUMER_KEY>',
                                        :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                      }
      end

      it 'empty default order details' do
        @pesapal_dev.order_details.should == {}
      end
    end

    context 'when mode specified as production' do

      before :each do
        @pesapal_prod = Pesapal::Merchant.new(:production)
      end

      it 'valid new object' do
        @pesapal_prod.should be_an_instance_of Pesapal::Merchant
      end

      it 'sets default environment variable' do
        @pesapal_prod.send(:env).should == 'production'
      end

      it 'config set with the default credentials' do
        @pesapal_prod.config.should == { :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                         :consumer_key => '<YOUR_CONSUMER_KEY>',
                                         :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                        }
      end

      it 'empty default order details' do
        @pesapal_prod.order_details.should == {}
      end
    end
  end
end
