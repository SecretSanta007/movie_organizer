# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movie_organizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'movie_organizer'
  spec.version       = MovieOrganizer::VERSION
  spec.authors       = ['Chris Blackburn']
  spec.email         = ['chris@midwiretech.com']
  spec.summary       = 'Organize movie files'
  spec.description   = spec.summary
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'midwire_common', '>= 0.1.15'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
  spec.add_development_dependency 'faker'

  spec.add_runtime_dependency 'mime-types'
  spec.add_runtime_dependency 'dotenv', '~> 1.0'
  spec.add_runtime_dependency 'titleize', '~> 1.3'
  spec.add_runtime_dependency 'streamio-ffmpeg'
  spec.add_runtime_dependency 'trollop'
  spec.add_runtime_dependency 'colored'
end
