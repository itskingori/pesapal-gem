require 'coveralls'
require 'webmock/rspec'

require_relative '../lib/pesapal'

Coveralls.wear!

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
