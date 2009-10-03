require 'httparty'
# require 'query_string'
# require 'evoke_client/base'
# require 'evoke_client/stub'

module Evoke
  class RecordInvalid < Exception; end

  def self.configure(base_uri)
    Evoke::Callback.base_uri(base_uri)
  end

  class Callback
    include HTTParty
    base_uri "http://evoke.thumblemonks.com"
    format :json

    def self.find(guid)
      callback = get("/callbacks/#{guid}")
      callback.empty? ? nil : new(callback)
    end

    def initialize(data)
      @data = data
    end

    def save
      response = self.class.post("/callbacks", @data)
      raise(Evoke::RecordInvalid, response["errors"]) if response.code == 422
      @data = response
    end

    def method_missing(method, *args, &block)
      @data.include?(method.to_s) ? @data[method.to_s] : super
    end
  end # Callback
end # Evoke

# class Evoke
#   class ConnectionRefused < Exception; end
# 
#   # Configuration
# 
#   def self.test?; @test == true; end
#   def self.test=(setting) @test = setting; end
# 
#   def self.host; @host || 'evoke.thumblemonks.com'; end
#   def self.host=(host) @host = host; end
# 
#   def self.port; @port; end
#   def self.port=(port) @port = port; end
# 
#   def self.host_and_port
#     [host, port].compact.join(':')
#   end
# 
#   # Logic
# 
#   def self.create_or_update!(*args)
#     prepare(*args).save
#   end
# 
#   def self.prepare(*args)
#     (test? ? EvokeClient::Stub : EvokeClient::Base).new(*args)
#   end
#   
# end
