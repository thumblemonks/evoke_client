require 'restclient'
require 'query_string'

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
    Evoke.new(*args).save
  end
  
  attr_reader :params, :headers

  def initialize(params={})
    @evoke = RestClient::Resource.new("http://#{Evoke.host_and_port}/callbacks")
    @params = params
    @params[:callback_at] = @params[:callback_at].utc if @params[:callback_at]
    @params[:data] = @params[:data].to_query_string if @params[:data]
  end

  def save
    begin
      @evoke[params[:guid]].get
      @evoke[params[:guid]].put(@params)
    rescue RestClient::ResourceNotFound
      @evoke.post(@params)
    rescue Errno::ECONNREFUSED
      raise ConnectionRefused, "Connection refused while connecting to #{Evoke.host_and_port}"
    end unless Evoke.test?
  end
end
