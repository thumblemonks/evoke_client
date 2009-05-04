require 'query_string'

class Evoke
  class ConnectionRefused < Exception; end

  def self.hostname_and_port
    "evoke.thumblemonks.com"
  end

  def self.create_or_update!(*args)
    Evoke.new(*args).save
  end
  
  attr_reader :params, :headers

  def initialize(params={})
    @evoke = RestClient::Resource.new("http://#{Evoke.hostname_and_port}/callbacks")
    @params = params
    @params[:callback_at] = @params[:callback_at].utc if @params[:callback_at]
    @params[:data] = @params[:data].to_query_string if @params[:data]
  end

  def save
    @evoke[params[:guid]].get
    @evoke[params[:guid]].put(@params)
  rescue RestClient::ResourceNotFound
    @evoke.post(@params)
  rescue Errno::ECONNREFUSED
    raise ConnectionRefused, "Connection refused while connecting to #{Evoke.hostname_and_port}"
  end
end
