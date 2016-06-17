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

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin\/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)\/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler',  '~> 1.12.5'
  spec.add_dependency 'rake',     '~> 11.2'
  spec.add_dependency 'rspec',    '~> 3.4'
  spec.add_dependency 'cucumber', '~> 2.3'
  spec.add_dependency 'rubocop',  '~> 0.40'
  spec.add_dependency 'aruba',    '~> 0.14'
  spec.add_dependency 'mysql2',   '~> 0.3.21'
  spec.add_dependency 'pry',      '~> 0.10.1'
  spec.add_dependency 'sshkit',   '~> 1.10.0'
end
