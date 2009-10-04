require 'rubygems'
require 'mocha'
require 'riot'

Riot::Situation.instance_eval { include Mocha::Standalone }

require 'evoke_client'

at_exit { Riot.report }
