require 'spec_helper'

describe Pesapal::Merchant do

  context 'when mode not specified' do

    before :each do
      @pesapal = Pesapal::Merchant.new
    end

    describe '#new' do

      it 'is valid object' do
        expect(@pesapal).to be_an_instance_of(Pesapal::Merchant)
      end

      it 'sets default environment variable' do
        expect(@pesapal.send(:env)).to eq 'development'
      end

      it 'sets default credentials' do
        expect(@pesapal.config).to eq({ :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                        :consumer_key => '<YOUR_CONSUMER_KEY>',
                                        :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                      })
      end

      it 'sets default order details' do
        expect(@pesapal.order_details).to eq({})
      end
    end

    describe '#set_env' do

      it 'sets default environment variable' do
        @pesapal.set_env
        expect(@pesapal.send(:env)).to eq 'development'
      end

      it 'sets endpoints for default environment' do
        expect(@pesapal.set_env).to eq({:postpesapaldirectorderv4 => 'http://demo.pesapal.com/API/PostPesapalDirectOrderV4',
                                        :querypaymentstatus=>'http://demo.pesapal.com/API/QueryPaymentStatus',
                                        :querypaymentdetails=>'http://demo.pesapal.com/API/QueryPaymentDetails'
                                      })
      end
    end

    describe '#generate_order_url' do

      it 'generates iframe url string' do
        @pesapal.order_details = { :amount => 1000,
                                   :description => 'This is the description for the test transaction.',
                                   :type => 'MERCHANT',
                                   :reference => '111-222-333',
                                   :first_name => 'Swaleh',
                                   :last_name => 'Mdoe',
                                   :email => 'test@example.com',
                                   :phonenumber => '+254711000333',
                                   :currency => 'KES'
                                }
        expect(@pesapal.generate_order_url).to include('http://demo.pesapal.com/API/PostPesapalDirectOrderV4')
      end
    end
  end

  context 'when mode is specified as development' do

    before :each do
      @pesapal = Pesapal::Merchant.new(:development)
    end

    describe '#new(:development)' do

      it 'is valid object' do
        expect(@pesapal).to be_an_instance_of(Pesapal::Merchant)
      end

      it 'sets environment variable' do
        expect(@pesapal.send(:env)).to eq 'development'
      end

      it 'sets credentials' do
        expect(@pesapal.config).to eq({ :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                        :consumer_key => '<YOUR_CONSUMER_KEY>',
                                        :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                      })
      end

      it 'sets order details' do
        expect(@pesapal.order_details).to eq({})
      end
    end

    describe '#set_env(:development)' do

      it 'sets environment variable' do
        @pesapal.set_env :development
        expect(@pesapal.send(:env)).to eq 'development'
      end

      it 'sets endpoints for environment' do
        expect(@pesapal.set_env :development).to eq({:postpesapaldirectorderv4 => 'http://demo.pesapal.com/API/PostPesapalDirectOrderV4',
                                                     :querypaymentstatus=>'http://demo.pesapal.com/API/QueryPaymentStatus',
                                                     :querypaymentdetails=>'http://demo.pesapal.com/API/QueryPaymentDetails'
                                                    })
      end
    end

    describe '#generate_order_url' do

      it 'generates iframe url string' do
        @pesapal.order_details = { :amount => 1000,
                                   :description => 'This is the description for the test transaction.',
                                   :type => 'MERCHANT',
                                   :reference => '111-222-333',
                                   :first_name => 'Swaleh',
                                   :last_name => 'Mdoe',
                                   :email => 'test@example.com',
                                   :phonenumber => '+254711000333',
                                   :currency => 'KES'
                                }
        expect(@pesapal.generate_order_url).to include('http://demo.pesapal.com/API/PostPesapalDirectOrderV4')
      end
    end
  end

  context 'when mode is specified as production' do

    before :each do
      @pesapal = Pesapal::Merchant.new(:production)
    end

    describe '#new(:production)' do

      it 'is valid object' do
        expect(@pesapal).to be_an_instance_of(Pesapal::Merchant)
      end

      it 'sets environment variable' do
        expect(@pesapal.send(:env)).to eq 'production'
      end

      it 'sets credentials' do
        expect(@pesapal.config).to eq({ :callback_url => 'http://0.0.0.0:3000/pesapal/callback',
                                        :consumer_key => '<YOUR_CONSUMER_KEY>',
                                        :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                                      })
      end

      it 'sets order details' do
        expect(@pesapal.order_details).to eq({})
      end
    end

    describe '#set_env(:production)' do

      it 'sets environment variable' do
        @pesapal.set_env :production
        expect(@pesapal.send(:env)).to eq 'production'
      end

      it 'sets endpoints for environment' do
        expect(@pesapal.set_env :production).to eq({:postpesapaldirectorderv4 => 'https://www.pesapal.com/API/PostPesapalDirectOrderV4',
                                                    :querypaymentstatus=>'https://www.pesapal.com/API/QueryPaymentStatus',
                                                    :querypaymentdetails=>'https://www.pesapal.com/API/QueryPaymentDetails'
                                                  })
      end
    end

    describe '#generate_order_url' do

      it 'generates iframe url string' do
        @pesapal.order_details = { :amount => 1000,
                                   :description => 'This is the description for the test transaction.',
                                   :type => 'MERCHANT',
                                   :reference => '111-222-333',
                                   :first_name => 'Swaleh',
                                   :last_name => 'Mdoe',
                                   :email => 'test@example.com',
                                   :phonenumber => '+254711000333',
                                   :currency => 'KES'
                                }
        expect(@pesapal.generate_order_url).to include('https://www.pesapal.com/API/PostPesapalDirectOrderV4')
      end
    end
  end
end
