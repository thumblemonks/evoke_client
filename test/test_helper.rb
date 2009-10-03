require 'rubygems'
require 'mocha'
require 'protest'

require 'evoke_client'

# Evoke.host = 'localhost'
# Evoke.port = 4567

Protest::Situation.instance_eval { include Mocha::Standalone }
