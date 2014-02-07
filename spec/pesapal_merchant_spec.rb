require 'spec_helper'

describe Pesapal::Merchant do

  describe '#new' do

    context 'when mode not specified' do

      before :each do
        @pesapal = Pesapal::Merchant.new
      end

      it 'valid object' do
        expect(@pesapal).to be_an_instance_of(Pesapal::Merchant)
      end

      it 'sets default environment variable' do
        expect(@pesapal.send(:env)).to eq 'development'
      end

      it 'default credentials' do
        expect(@pesapal.config).to eq({ :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                        :consumer_key => '<YOUR_CONSUMER_KEY>',
                                        :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                      })
      end

      it 'default order details' do
        expect(@pesapal.order_details).to eq({})
      end
    end

    context 'when mode specified as development' do

      before :each do
        @pesapal_dev = Pesapal::Merchant.new(:development)
      end

      it 'valid object' do
        expect(@pesapal_dev).to be_an_instance_of(Pesapal::Merchant)
      end

      it 'sets default environment variable' do
        expect(@pesapal_dev.send(:env)).to eq 'development'
      end

      it 'default credentials' do
        expect(@pesapal_dev.config).to eq({ :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                            :consumer_key => '<YOUR_CONSUMER_KEY>',
                                            :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                          })
      end

      it 'default order details' do
        expect(@pesapal_dev.order_details).to eq({})
      end
    end

    context 'when mode specified as production' do

      before :each do
        @pesapal_prod = Pesapal::Merchant.new(:production)
      end

      it 'valid object' do
        expect(@pesapal_prod).to be_an_instance_of(Pesapal::Merchant)
      end

      it 'sets default environment variable' do
        expect(@pesapal_prod.send(:env)).to eq 'production'
      end

      it 'default credentials' do
        expect(@pesapal_prod.config).to eq({ :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                             :consumer_key => '<YOUR_CONSUMER_KEY>',
                                             :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                            })
      end

      it 'default order details' do
        expect(@pesapal_prod.order_details).to eq({})
      end
    end
  end
end
