require 'rubygems'
require 'rake'

desc 'Default task: run all tests'
task :default => [:test]

desc 'Run all tests'
task :test do
  require 'protest'
  $:.concat ['./lib', './test']
  Dir.glob("./test/*_test.rb").each { |test| require test }
  Protest.report
end

desc "Open an irb session preloaded with this library"
task :console do
  exec "irb -rubygems -r ./lib/evoke_client.rb"
end
