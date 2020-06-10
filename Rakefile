require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yaml'

################################
# Tests                        #
################################

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = ['spec/yoti']
end

RSpec::Core::RakeTask.new(:test_generators) do |t|
  t.pattern = ['spec/generators']
end

################################
# Rubocop                      #
################################

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--config', 'rubocop.yml']
end

################################
# Documentation                #
################################

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.stats_options = ['--list-undoc']
end

yardstick_options = YAML.load_file('yardstick.yml')

require 'yardstick/rake/measurement'
Yardstick::Rake::Measurement.new(:measurement, yardstick_options) do |measurement|
  measurement.output = 'measurement/report.txt'
end

################################
# Defaults                     #
################################

task default: %i[spec test_generators rubocop]
