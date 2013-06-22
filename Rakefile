require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => [:spec]

namespace :spec do
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = 'spec/unit/**/*_spec.rb'
  end
end
task :spec => ['spec:unit']
