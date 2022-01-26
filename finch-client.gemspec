# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finch/client/version'

Gem::Specification.new do |spec|
  spec.name = 'finch-client'
  spec.version = Finch::Client::VERSION
  spec.authors = ['Kieran Eglin', 'Aron Macarow']
  spec.email = ['engineering@percentpledge.com']

  spec.summary = 'A gem for interacting with the Finch API'
  spec.description = 'A Ruby interface for the Finch API (tryfinch.com)'
  spec.homepage = 'https://github.com/Percent-Pledge/finch-client'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '>= 0.15.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.25'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.8'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
