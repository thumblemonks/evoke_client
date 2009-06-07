require 'restclient'

module EvokeClient
  class Base
    attr_reader :params, :headers

    def initialize(params={})
      @evoke = ::RestClient::Resource.new("http://#{Evoke.host_and_port}/callbacks")
      @params = params
      @params[:callback_at] = @params[:callback_at].utc if @params[:callback_at]
      @params[:data] = @params[:data].to_query_string if @params[:data]
    end

    def save
      @evoke[params[:guid]].get
      @evoke[params[:guid]].put(@params)
    rescue ::RestClient::ResourceNotFound
      @evoke.post(@params)
    rescue Errno::ECONNREFUSED
      raise Evoke::ConnectionRefused, "Connection refused while connecting to #{Evoke.host_and_port}"
    end
  end # Base
end # EvokeClient
