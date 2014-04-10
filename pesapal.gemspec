lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pesapal/version'

Gem::Specification.new do |spec|
  spec.name          = 'pesapal'
  spec.version       = Pesapal::VERSION
  spec.date          = Time.new.getutc.strftime('%Y-%m-%d')
  spec.authors       = ['Job King\'ori Maina']
  spec.email         = ['j@kingori.co']
  spec.description   = 'Make authenticated Pesapal API calls without the fuss!'
  spec.summary       = 'Make authenticated Pesapal API calls without the fuss! Handles all the oAuth stuff abstracting any direct interaction with the API endpoints so that you can focus on what matters. Building awesome.'
  spec.homepage      = 'http://kingori.co/pesapal-gem/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5.2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14.1'

  spec.add_dependency 'htmlentities'
end
