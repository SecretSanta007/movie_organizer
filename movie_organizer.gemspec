# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'movie_organizer/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'movie_organizer'
  spec.version       = MovieOrganizer::VERSION
  spec.authors       = ['Chris Blackburn']
  spec.email         = ['87a1779b@opayq.com']
  spec.summary       = 'Automatically organize movies, tv shows and home videos.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/midwire/movie_organizer'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.3.0'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'midwire_common', '~> 1.1'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'

  spec.add_runtime_dependency 'colored'
  spec.add_runtime_dependency 'mime-types'
  spec.add_runtime_dependency 'net-scp', '~> 1.2'
  # spec.add_runtime_dependency 'streamio-ffmpeg'
  spec.add_runtime_dependency 'titleize', '~> 1.3'
  spec.add_runtime_dependency 'trollop'
end
# rubocop:enable Metrics/BlockLength
