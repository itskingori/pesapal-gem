Pesapal RubyGem
===============

<a href="http://badge.fury.io/rb/pesapal"><img src="https://badge.fury.io/rb/pesapal@2x.png" alt="Gem Version" height="18"></a>

Make authenticated Pesapal API calls without the fuss! Handles all the [oAuth
stuff][1] abstracting any direct interaction with the API endpoints so that you
can focus on what matters. _Building awesome_.

This gem is work in progress. At the moment, the only functionality built-in is
posting an order i.e. fetching the URL that is required to display the post-
order iframe. Everything else should be easy to do as the groundwork has already
been laid. If you are [feeling generous and want to contribute, feel free][9].

Submit [issues and requests here][6] and [find all the releases here][12].

The gem should be [up on RubyGems.org][7] and it's [accompanying RubyDoc reference here][13].

_Ps: No 3rd party oAuth library dependencies, it handles all the oAuth flows on
it's own so your app is one dependency less._


Installation
------------

Add this line to your application's Gemfile:

    gem 'pesapal'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pesapal


Usage
-----


### Setup ###

Initialize Pesapal object and choose the mode, there are two modes;
`:development` and `:production`. They determine if the code will interact
with the testing or live Pesapal API.

```ruby
# initiate pesapal object set to development mode
pesapal = Pesapal::Merchant.new(:development)
```

Now set the Pesapal credentials. This assumes that you've chosen the appropriate
credentials as they differ based on the mode chosen above (Pesapal provide the
keys). Replace the placeholders below with your own credentials.

```ruby
# set pesapal api credentials
pesapal.credentials = { :consumer_key => '<YOUR_CONSUMER_KEY>',
                        :consumer_secret => '<YOUR_CONSUMER_SECRET>' 
                    }
```


### Post Order ###

Once you've set up the credentials, set up the order details in a hash as shown
in the example below ... all keys **MUST** be present. If there's one that you
wish to ignore just leave it with a blank string but make sure it's included
e.g. the phonenumber.

```ruby
#set order details 
pesapal.order_details = { :amount => 1000,
                          :description => 'this is the transaction description',
                          :type => 'MERCHANT',
                          :reference => 808-707-606,
                          :first_name => 'Swaleh',
                          :last_name => 'Mdoe',
                          :email => 'user@example.com',
                          :phonenumber => '+254722222222'
                        }
```

By default the callback is set to `http://0.0.0.0:3000/pesapal/callback` on
instantiation but you can easily set it to whatever works for you as shown
below. After the user does all that payment stuff (on the iframe which you will
generate in the next step), the response will be sent to this url, so it's
important that you set the correct callback url in your app before generating
the order url.

```ruby
pesapal.callback_url = 'WHATEVER_URL_YOU_WANT'
```

Then generate the transaction url as below. In the example, the value is
assigned to the variable `order_url` which you can pass on to the templating
system of your choice to generate an iframe. Please note that this method
utilizes all that information set in the previous steps in generating the url so
it's important that it's the last step in the post order process.

```ruby
# generate transaction url
order_url = pesapal.generate_order_url

# order_url will a string with the url example;
# http://demo.pesapal.com/API/PostPesapalDirectOrderV4?oauth_callback=http%3A%2F%2F1.2.3.4%3A3000%2Fpesapal%2Fcallback&oauth_consumer_key=A9MXocJiHK1P4w0M%2F%2FYzxgIVMX557Jt4&oauth_nonce=13804335543pDXs4q3djsy&oauth_signature=BMmLR0AVInfoBI9D4C38YDA9eSM%3D&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1380433554&oauth_version=1.0&pesapal_request_data=%26lt%3B%3Fxml%20version%3D%26quot%3B1.0%26quot%3B%20encoding%3D%26quot%3Butf-8%26quot%3B%3F%26gt%3B%26lt%3BPesapalDirectOrderInfo%20xmlns%3Axsi%3D%26quot%3Bhttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema-instance%26quot%3B%20xmlns%3Axsd%3D%26quot%3Bhttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%26quot%3B%20Amount%3D%26quot%3B1000%26quot%3B%20Description%3D%26quot%3Bthis%20is%20the%20transaction%20description%26quot%3B%20Type%3D%26quot%3BMERCHANT%26quot%3B%20Reference%3D%26quot%3B808%26quot%3B%20FirstName%3D%26quot%3BSwaleh%26quot%3B%20LastName%3D%26quot%3BMdoe%26quot%3B%20Email%3D%26quot%3Bj%40kingori.co%26quot%3B%20PhoneNumber%3D%26quot%3B%2B254722222222%26quot%3B%20xmlns%3D%26quot%3Bhttp%3A%2F%2Fwww.pesapal.com%26quot%3B%20%2F%26gt%3B
```


Contributing
------------

1. Make sure you've read the [M.O. ★][14] ([blog article here][16])
2. Especially [the part about my conventions when writing and merging new features][15]
2. [Fork it][8]
2. Create your feature branch (`git checkout -b BRANCH_NAME`)
3. Commit your changes (`git commit -am 'AWESOME COMMIT MESSAGE'`)
4. Push to the branch (`git push origin BRANCH_NAME`)
5. Create new pull request and we can [have the conversations here][17]


References
----------

* [oAuth 1.0 Spec][1]
* [Developing a RubyGem using Bundler][2]
* [Make your own gem][3]
* [Pesapal API Reference (Official)][4]
* [Pesapal PHP API Reference (Unofficial)][5]


License
-------

[King'ori J. Maina][10] © 2013. The [MIT License bundled therein][11] is a
permissive license that is short and to the point. It lets people do anything
they want as long as they provide attribution and waive liability.

[1]: http://oauth.net/core/1.0/
[2]: https://github.com/radar/guides/blob/master/gem-development.md
[3]: http://guides.rubygems.org/make-your-own-gem/
[4]: http://developer.pesapal.com/how-to-integrate/api-reference
[5]: https://github.com/itsmrwave/pesapal-php#pesapal-php-api-reference-unofficial
[6]: https://github.com/itsmrwave/pesapal-rubygem/issues
[7]: http://rubygems.org/gems/pesapal
[8]: https://github.com/itsmrwave/pesapal-rubygem/fork
[9]: https://github.com/itsmrwave/pesapal-rubygem#contributing
[10]: http://kingori.co/
[11]: https://github.com/itsmrwave/pesapal-rubygem/blob/master/LICENSE.txt
[12]: https://github.com/itsmrwave/pesapal-rubygem/releases/
[13]: http://rubydoc.info/gems/pesapal/
[14]: https://github.com/itsmrwave/mo
[15]: https://github.com/itsmrwave/mo/tree/master/convention#-convention
[16]: http://kingori.co/articles/2013/09/modus-operandi/
[17]: https://github.com/itsmrwave/pesapal-rubygem/pulls
