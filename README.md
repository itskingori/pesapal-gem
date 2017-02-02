[Pesapal RubyGem][2]
===============

[![Gem Version](https://badge.fury.io/rb/pesapal.svg)](https://badge.fury.io/rb/pesapal)
[![Build Status](https://travis-ci.org/itsmrwave/pesapal-gem.svg?branch=master)](https://travis-ci.org/itsmrwave/pesapal-gem)
[![Code Climate](https://codeclimate.com/github/itsmrwave/pesapal-gem/badges/gpa.svg)](https://codeclimate.com/github/itsmrwave/pesapal-gem)
[![Coverage Status](https://coveralls.io/repos/github/itsmrwave/pesapal-gem/badge.svg?branch=master)](https://coveralls.io/github/itsmrwave/pesapal-gem?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/itsmrwave/pesapal-gem.svg)](https://gemnasium.com/github.com/itsmrwave/pesapal-gem)


Basically it's a gem that makes it easy to integrate your app with
[Pesapal][1]'s payment gateway. It Handles all the [oAuth stuff][3] abstracting
any direct interaction with the API endpoints so that you can focus on what
matters. _Building awesome_.

The gem should be [up on RubyGems.org][4], it's [accompanying API reference
here][9], the [CHANGELOG here][5] and [all the releases here][6].

[Check out the homepage for details][2] i.e. on usage, support, issues,
contributing, testing etc.

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

For Rails, you need to run the generator to create sample pesapal.yml file:

    rails generate pesapal:install


License
-------

[King'ori J. Maina][7] © 2013-2017. The [MIT License bundled therein][8] is a
permissive license that is short and to the point. It lets people do anything
they want as long as they provide attribution and waive liability.

[1]: https://www.pesapal.com/
[2]: http://itsmrwave.github.io/pesapal-gem
[3]: http://oauth.net/core/1.0/
[4]: http://rubygems.org/gems/pesapal
[5]: https://raw.githubusercontent.com/itsmrwave/pesapal-gem/master/CHANGELOG.md
[6]: https://github.com/itsmrwave/pesapal-gem/releases/
[7]: http://kingori.co/
[8]: https://raw.githubusercontent.com/itsmrwave/pesapal-gem/master/LICENSE.md
[9]: http://rubydoc.info/gems/pesapal/frames/file/README.md
[10]: http://mogetutu.com/
[11]: https://github.com/mogetutu
