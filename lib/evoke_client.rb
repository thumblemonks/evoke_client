require 'evoke_client/base'
require 'httparty'

Evoke::Callback.instance_eval do
  include HTTParty
  base_uri "http://localhost:3000"
  format :json
end
