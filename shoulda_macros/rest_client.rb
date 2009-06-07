module EvokeClient
  module RestClient
    module Shoulda
      def expect_restful_request(method, *args)
        ::RestClient::Resource.any_instance.expects(method).with(*args)
      end

      def expect_restful_request_failure(method, *raises)
        ::RestClient::Resource.any_instance.expects(method).raises(*raises)
      end

    end # Shoulda
  end # RestClient
end # EvokeClient

Test::Unit::TestCase.instance_eval { include EvokeClient::RestClient::Shoulda }
