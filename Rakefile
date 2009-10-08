require 'rubygems'
require 'rake'

desc 'Default task: run all tests'
task :default => [:test]

desc 'Run all tests'
task :test do
  $:.concat ['./lib', './test']
  Dir.glob("./test/*_test.rb").each { |test| require test }
end

desc "Open an irb session preloaded with this library"
task :console do
  exec "irb -rubygems -I./lib -r evoke_client"
end
