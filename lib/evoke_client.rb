require 'httparty'
require 'evoke_client/base'

Evoke::Callback.instance_eval do
  include HTTParty
  base_uri "http://localhost:3000"
  format :json
end
