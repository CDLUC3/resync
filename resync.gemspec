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

  origin = `git config --get remote.origin.url`.chomp
  origin_uri = origin.start_with?('http') ? URI(origin) : URI(origin.gsub(%r{git@([^:]+)(.com|.org)[^\/]+}, 'http://\1\2'))
  spec.homepage = URI::HTTP.build(host: origin_uri.host, path: origin_uri.path.chomp('.git')).to_s

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mime-types', '~> 3.0'
  spec.add_dependency 'typesafe_enum', '~> 0.1', '>= 0.1.5'
  spec.add_dependency 'xml-mapping', '~> 0.10'
  spec.add_dependency 'xml-mapping_extensions', '~> 0.4', '>= 0.4.8'

  spec.add_development_dependency 'equivalent-xml', '~> 0.6.0'
  spec.add_development_dependency 'rake', '>= 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 0.52'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
  spec.add_development_dependency 'simplecov-console', '~> 0.2.0'
  spec.add_development_dependency 'yard', '~> 0.9', '>= 0.9.12'
end
