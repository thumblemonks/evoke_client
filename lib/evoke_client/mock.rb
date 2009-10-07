require 'evoke_client/base'
require 'httparty'

module Evoke
  module HTTMockParty
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def base_uri(uri=nil)
        @base_uri = uri if uri
        @base_uri
      end

      def format(fmt=nil)
        @format = fmt if fmt
        @format
      end

      #
      # The mock part. Your code will call these methods and get a real HTTParty::Response

      def get(path, query={}) HTTMockParty.router("get").dispatch(path, query); end
      def post(path, query={}) HTTMockParty.router("post").dispatch(path, query); end
      def put(path, query={}) HTTMockParty.router("put").dispatch(path, query); end
      def delete(path, query={}) HTTMockParty.router("delete").dispatch(path, query); end
    end # ClassMethods

    #
    # The shunt part. Setting up routers for responses

    def self.get(path, query={}) router("get").maps(path, query); end
    def self.post(path, query={}) router("post").maps(path, query); end
    def self.put(path, query={}) router("put").maps(path, query); end
    def self.delete(path, query={}) router("delete").maps(path, query); end

    class Router
      def initialize; @routes = {}; end
      def maps(*args) @routes[args.inspect] = Responder.new; end
      def dispatch(*args) @routes[args.inspect].process; end
    end

    class Responder
      def process
        HTTParty::Response.new(@delegate || "", @body, @code, @message, @headers)
      end

      def ok; status(200, "Ok"); end
      def created; status(201, "Created"); end
      def not_found; status(404, "Not Found"); end
      def unprocessable_entity; status(422, "Unprocessable Entity"); end
      def internal_server_error; status(500, "Internal Server Error"); end

      def responds(delegate, body="", code=nil, message=nil, headers={})
        @delegate, @body, @code, @message, @headers = delegate, body, code, message, headers
        self
      end
    private
      def status(code, message)
        @code, @message = code, message
        self
      end
    end

  private
    def self.routers; @routers ||= {}; end
    def self.router(method) routers[method] ||= Router.new; end
  end # HTTMockParty
end # Evoke

Evoke::Callback.instance_eval do
  include Evoke::HTTMockParty
  base_uri "http://test:3000"
  format :json
end
