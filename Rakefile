require 'rubygems'
require 'rake'
# require 'rake/testtask'

desc 'Default task: run all tests'
task :default => [:test]

desc 'Run all tests'
task :test do
  require 'protest'
  $:.concat ['./lib', './test']
  Dir.glob("./test/*_test.rb").each { |test| require test }
  Protest.report
end
# task :test => [:set_test_env]
# Rake::TestTask.new do |t|
#   t.test_files = FileList['test/*_test.rb']
#   t.verbose = true
# end

desc "Open an irb session preloaded with this library"
task :console do
  exec "irb -rubygems -r ./lib/evoke_client.rb"
end
