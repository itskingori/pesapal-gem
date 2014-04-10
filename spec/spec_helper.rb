require 'coveralls'
Coveralls.wear!

require_relative '../lib/pesapal'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
