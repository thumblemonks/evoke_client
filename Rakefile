require 'rubygems'
require 'rake'
require 'rake/testtask'

desc 'Default task: run all tests'
task :default => [:test]

task(:set_test_env) { ENV['APP_ENV'] ||= 'test' }

task(:environment) { }

task :test => [:set_test_env]
desc 'Run all tests'
Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end