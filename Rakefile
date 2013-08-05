require 'yard'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :yard

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'spec/**/*_spec.rb']
  t.options = ['--private'] # optional arguments
end
