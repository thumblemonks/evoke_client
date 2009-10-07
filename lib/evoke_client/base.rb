module Evoke
  class RecordError < Exception; end
  class RecordInvalid < RecordError; end
  class RecordNotFound < RecordError; end

  def self.configure(base_uri)
    Evoke::Callback.base_uri(base_uri)
  end

  class Callback
    def self.find(guid)
      callback = get("/callbacks/#{guid}")
      callback.empty? ? nil : new(callback.merge(:new_record => false))
    end

    def self.create_or_update(data)
      callback = find(data["guid"])
      ( callback || (callback = new(data)) ).save
      callback
    end

    def initialize(data)
      @new_record = determine_if_new_record(data.delete(:new_record))
      @data = data
    end

    def new_record?; @new_record; end

    def save
      args = new_record? ? [:post, "/callbacks", @data] : [:put, "/callbacks/#{guid}", @data]
      handle_response(self.class.send(*args)) { |response| @data = response }
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
        when 404 then raise(Evoke::RecordNotFound)
        when 422 then raise(Evoke::RecordInvalid, response["errors"])
        when 200..201 then yield(response)
        else raise(Evoke::RecordError, "#{response.code} - #{response.message}")
      end
    end
    
    def determine_if_new_record(condition)
      condition.nil? || condition
    end
  end # Callback
end # Evoke
