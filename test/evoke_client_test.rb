require File.join(File.dirname(__FILE__), 'test_helper')

class EvokeTest < Test::Unit::TestCase
  def setup
    @params = {:url => 'foo', :callback_at => Time.now}
  end

  context "initializing a new evokation" do
    setup do
      @data = {:foo => 'bar', 'goo' => 'car'}
      @expected_data = "foo=bar&goo=car"
      @evoke = Evoke.new(@params.merge(:data => @data))
    end
    
    before_should("convert times to UTC") { Time.any_instance.expects(:utc) }

    should "convert data to a single escaped parameter string" do
      assert_match /foo=bar&?/, @evoke.params[:data]
      assert_match /goo=car&?/, @evoke.params[:data]
    end
  end

  context "saving" do
    context "a new callback" do
      setup do
        expect_restful_request_failure(:get, ::RestClient::ResourceNotFound)
        expect_restful_request(:post, @params)
        @evoke = Evoke.new(@params)
      end
      should("try and post params after not finding a resource") { @evoke.save }
    end

    context "an existing callback" do
      setup do
        expect_restful_request(:get)
        expect_restful_request(:put, @params)
        @evoke = Evoke.new(@params)
      end
      should("try and put params after finding a resource") { @evoke.save }
    end
  end

  context "create_or_update!" do
    should "initialize instance and call save" do
      fake_evoke = Evoke.new({})
      Evoke.expects(:new).with(@params).returns(fake_evoke)
      fake_evoke.expects(:save)
      Evoke.create_or_update!(@params)
    end
  end

  context "connection refused" do
    setup do
      RestClient::Resource.any_instance.expects(:get).raises(Errno::ECONNREFUSED)
    end

    should "reraise Evoke::ConnectionRefused when saving" do
      assert_raise(Evoke::ConnectionRefused) { Evoke.new({}).save }
    end
    
    should "reraise Evoke::ConnectionRefused when storing" do
      assert_raise(Evoke::ConnectionRefused) { Evoke.create_or_update!({}) }
    end
  end

  context "host and port:" do
    context "when unchanged" do
      setup do
        Evoke.host = nil
        Evoke.port = nil
      end
      should("return default host") { assert_equal 'evoke.thumblemonks.com', Evoke.host }
      should("return default port") { assert_nil Evoke.port }
      should("return default host and port") { assert_equal 'evoke.thumblemonks.com', Evoke.host_and_port }
    end

    context "when changed" do
      setup do
        Evoke.host = 'example.com'
        Evoke.port = 4567
      end

      should("return specified host") { assert_equal 'example.com', Evoke.host }
      should("return specified port") { assert_equal 4567, Evoke.port }
      should("return specified host and port") { assert_equal 'example.com:4567', Evoke.host_and_port }
    end
  end

end
