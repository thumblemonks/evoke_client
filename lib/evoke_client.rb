require 'httparty'

module Evoke
  class RecordInvalid < Exception; end

  def self.configure(base_uri)
    Evoke::Callback.base_uri(base_uri)
  end

  class Callback
    include HTTParty
    base_uri "http://localhost:3000"
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
