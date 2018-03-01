# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

begin
  require 'midwire_common/rake_tasks'
rescue LoadError
  puts ">>> Could not load 'midwire_common' gem."
  exit
end
