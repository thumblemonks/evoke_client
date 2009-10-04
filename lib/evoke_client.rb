require 'httparty'

module Evoke
  class RecordError < Exception; end
  class RecordInvalid < RecordError; end
  class RecordNotFound < RecordError; end

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
      handle_response(self.class.post("/callbacks", @data)) { |response| @data = response }
    end

    def destroy
      handle_response(self.class.delete("/callbacks/#{guid}")) { |response| nil }
    end

    def method_missing(method, *args, &block)
      @data.include?(method.to_s) ? @data[method.to_s] : super
    end
  private
    def handle_response(response, &block)
      case response.code
        when 404; raise(Evoke::RecordNotFound)
        when 422; raise(Evoke::RecordInvalid, response["errors"])
        else yield(response)
      end
    end
  end # Callback
end # Evoke
