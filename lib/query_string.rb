module EvokeClient
  module Hash
    def to_query_string
      map do |key, val|
        "#{key}=#{val}"
      end.join('&')
    end
  end # Hash

  module String
    alias_method :to_query_string, :to_s
  end # String
end # EvokeClient

Hash.instance_eval { include EvokeClient::Hash }
String.instance_eval { include EvokeClient::String }