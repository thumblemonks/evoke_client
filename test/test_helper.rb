require 'rubygems'
require 'shoulda'
require 'mocha'
require 'redgreen'

Shoulda.autoload_macros(File.join(File.dirname(__FILE__), '..'))

require 'evoke_client'

Evoke.host = 'localhost'
Evoke.port = 4567