# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'resync/version'
require 'uri'

Gem::Specification.new do |spec|
  spec.name = 'resync'
  spec.version = Resync::VERSION
  spec.authors = ['David Moles']
  spec.email = ['david.moles@ucop.edu']
  spec.summary = 'Utility library for ResourceSync'
  spec.description = 'A Ruby gem for working with the ResourceSync web synchronization framework'
  spec.license = 'MIT'

  origin_uri = URI(`git config --get remote.origin.url`.chomp)
  spec.homepage = URI::HTTP.build(host: origin_uri.host, path: origin_uri.path.chomp('.git')).to_s

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mime-types', '~> 2.5'
  spec.add_dependency 'ruby-enum', '~> 0.4'
  spec.add_dependency 'xml-mapping', '~> 0.10'
  spec.add_dependency 'xml-mapping_extensions', '~> 0.1.0'

  spec.add_development_dependency 'equivalent-xml', '~> 0.6.0'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 0.32'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
  spec.add_development_dependency 'simplecov-console', '~> 0.2.0'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
