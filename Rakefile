# ------------------------------------------------------------
# RSpec

require 'rspec/core'
require 'rspec/core/rake_task'

namespace :spec do

  desc 'Run all unit tests'
  RSpec::Core::RakeTask.new(:unit) do |task|
    task.rspec_opts = %w(--color --format documentation --order default)
    task.pattern = 'unit/**/*_spec.rb'
  end

  desc 'Run all acceptance tests'
  RSpec::Core::RakeTask.new(:acceptance) do |task|
    task.rspec_opts = %w(--color --format documentation --order default)
    task.pattern = 'acceptance/**/*_spec.rb'
  end

  task all: [:unit, :acceptance]
end

desc 'Run all tests'
task spec: 'spec:all'

# ------------------------------------------------------------
# RuboCop

require 'rubocop/rake_task'
RuboCop::RakeTask.new

# ------------------------------------------------------------
# Defaults

task default: [:spec, :rubocop]
