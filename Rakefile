require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'spec/**/*_spec.rb']
  t.options = ['--private'] # optional arguments
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end

task :default => :yard
