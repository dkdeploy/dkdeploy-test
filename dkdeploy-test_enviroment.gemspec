# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dkdeploy/test_environment/version'

Gem::Specification.new do |spec|
  spec.name          = 'dkdeploy-test_environment'
  spec.version       = Dkdeploy::TestEnvironment::Version
  spec.license       = 'MIT'
  spec.authors       = ['Lars Tode', 'Timo Webler', 'Kieran Hayes', 'Nicolai Reuschling', 'Johannes Goslar']
  spec.email         = ['lars.tode@dkd.de', 'timo.webler@dkd.de', 'kieran.hayes@dkd.de', 'nicolai.reuschling@dkd.de', 'johannes.goslar@dkd.de']
  spec.description   = 'test infrastructure for dkdeploy'
  spec.summary       = 'dkdeploy-test_environment provides a test application for dkdeploy'
  spec.homepage      = 'https://github.com/dkdeploy/dkdeploy-test_environment'
  spec.required_ruby_version = '~> 2.2'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin\/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)\/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
  spec.add_dependency 'rake'

  spec.add_development_dependency 'aruba',    '~> 0.14'
  spec.add_development_dependency 'mysql2',   '~> 0.3'
  spec.add_development_dependency 'pry',      '~> 0.10.3'
  spec.add_development_dependency 'cucumber', '~> 2.4'
  spec.add_development_dependency 'rspec',    '~> 3.5'
  spec.add_development_dependency 'rubocop',  '~> 0.48.1'
  spec.add_development_dependency 'sshkit',   '~> 1.13'
end
