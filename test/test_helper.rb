require 'rubygems'
require 'mocha'
require 'protest'

require 'evoke_client'

# If we need methods like #stub, #anything, etc. uncomment the below line
Protest::Situation.instance_eval { include Mocha::Standalone }
