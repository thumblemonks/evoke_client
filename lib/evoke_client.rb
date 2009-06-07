require 'query_string'
require 'evoke_client/base'
require 'evoke_client/stub'

class Evoke
  class ConnectionRefused < Exception; end

  # Configuration

  def self.test?; @test == true; end
  def self.test=(setting) @test = setting; end

  def self.host; @host || 'evoke.thumblemonks.com'; end
  def self.host=(host) @host = host; end

  def self.port; @port; end
  def self.port=(port) @port = port; end

  def self.host_and_port
    [host, port].compact.join(':')
  end

  # Logic

  def self.create_or_update!(*args)
    prepare(*args).save
  end

  def self.prepare(*args)
    (test? ? EvokeClient::Stub : EvokeClient::Base).new(*args)
  end
  
end
