require 'bundler'
Bundler::GemHelper.install_tasks

# gem tests for TDD
require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end


task :default => :test