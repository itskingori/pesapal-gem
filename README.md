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

_Ps 2: We are still at pre-release stage ... target is version 1.0.0 for a
public release (suitable for production deployment with the basic functionality
in place). As a result always check the documentation carefully on upgrades to
mitigate breaking changes._


Installation
------------

Add this line to your application's Gemfile:

    gem 'pesapal'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pesapal

After you install Pesapal and add it to your Gemfile, you need to run the generator:

    rails generate pesapal:install


Usage
-----


### Setup ###

Initialize Pesapal object and choose the mode, there are two modes;
`:development` and `:production`. They determine if the code will interact
with the testing or the live Pesapal API.

```ruby
# initiate pesapal object set to development mode
pesapal = Pesapal::Merchant.new(:development)
```

You can set the configuration details from a YAML file at the location of
your choice upon initialization as shown in the example below for a Rails app.
The second parameter is optional and has a default value of
`"#{Rails.root}/config/pesapal.yml"` if left out as in the example above.

```ruby
# initiate pesapal object set to development mode and use the YAML file found at
# the specified location
pesapal = Pesapal::Merchant.new(:development, "<PATH_TO_YAML_FILE>")
```

And the YAML file should look something like this. Feel free to change to the
appropriate values.

```yaml
development:
    callback_url: 'http://0.0.0.0:3000/pesapal/callback'
    consumer_key: '<YOUR_CONSUMER_KEY>'
    consumer_secret: '<YOUR_CONSUMER_SECRET>'

production:
    callback_url: 'http://1.2.3.4:3000/pesapal/callback'
    consumer_key: '<YOUR_CONSUMER_KEY>'
    consumer_secret: '<YOUR_CONSUMER_SECRET>'
```

If the YAML file does not exist, then the object is set up with some bogus
credentials which would not work anyway and therefore, the next logical step is
that you set them yourself. Which, you can do using a hash as shown below
(please note that Pesapal provides different keys for different modes and since
this is like an override, there's the assumption that you chose the right one).

```ruby
# set pesapal api configuration manually (override YAML & bogus credentials)
pesapal.config = {  :callback_url => 'http://0.0.0.0:3000/pesapal/callback'
                    :consumer_key => '<YOUR_CONSUMER_KEY>',
                    :consumer_secret => '<YOUR_CONSUMER_SECRET>'
                  }
```

_Ps: Make sure this hash has the appropriate values before running any methods
that interact with the API as the methods pick from these values. This means
that you can also override them at runtime for a truly dynamic/complex app that
might have different values for different scenarios._


### Post Order ###

Once you've finalized the configuration, set up the order details in a hash as
shown in the example below ... all keys **MUST** be present. If there's one that
you wish to ignore just leave it with a blank string but make sure it's included
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

_Ps: Please note the `:callback_url` value in the `pesapal.config` hash ...
after the user successfully posts the order, the response will be sent to this
url. Refer to [official Pesapal Step-By-Step integration guide][18] for more
details._


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
* [Pesapal Step-By-Step Reference (Official)][18]
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
[18]: http://developer.pesapal.com/how-to-integrate/step-by-step
