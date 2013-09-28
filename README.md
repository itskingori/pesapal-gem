Pesapal RubyGem
===============

Make authenticated Pesapal API calls without the fuss! Handles all the [oAuth
stuff][1] abstracting any direct interaction with the API endpoints so that you
can focus on what matters. _Building awesome_.

This gem is work in progress. At the moment, the only functionality built-in is
posting an order i.e. fetching the URL that is required to display the post-
order iframe. Everything else should be easy to do as the groundwork has already
been laid. If you are [feeling generous and want to contribute, feel free][9].

Submit [issues and requests here][6]. The gem should be [up on RubyGems.org][7].

_Ps: No 3rd party oAuth library dependencies, it handles all the oAuth flows on
it's own so it's light on your app._


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
`:development` and `:production`. They determine if you the code will interact
with Pesapal for testing or for a live deployment.

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

Then generate the transaction url as below. In the example, the value is
assigned to the variable `order_url` which you can pass on to the templating
system of your to generate an iframe.

```ruby
# generate transaction url
order_url = pesapal.generate_order_url
```


Contributing
------------

1. [Fork it][8]
2. Create your feature branch (`git checkout -b wip-my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature with awesome'`)
4. Push to the branch (`git push origin wip-my-new-feature`)
5. Create new pull request

_Ps: Please prefix branch name with 'wip-' ... means 'work in progress'._


References
----------

* [oAuth 1.0 Spec][1]
* [Developing a RubyGem using Bundler][2]
* [Make your own gem][3]
* [Pesapal API Reference (Official)][4]
* [Pesapal PHP API Reference (Unofficial)][5]

[1]: http://oauth.net/core/1.0/
[2]: https://github.com/radar/guides/blob/master/gem-development.md
[3]: http://guides.rubygems.org/make-your-own-gem/
[4]: http://developer.pesapal.com/how-to-integrate/api-reference
[5]: https://github.com/itsmrwave/pesapal-php#pesapal-php-api-reference-unofficial
[6]: https://github.com/itsmrwave/pesapal-rubygem/issues
[7]: http://rubygems.org/gems/pesapal
[8]: https://github.com/itsmrwave/pesapal-rubygem/fork
[9]: https://github.com/itsmrwave/pesapal-rubygem#contributing
