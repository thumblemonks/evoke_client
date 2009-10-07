require 'teststrap'

context "creating a callback" do
  setup do
    good_response = HTTParty::Response.new({"url" => "http://foo.bar"}, "", 201, "Created")
    bad_response = HTTParty::Response.new({"errors" => ["blah"]}, "", 422, "Unprocessable Entity")
    unknown_response = HTTParty::Response.new("", "", 500, "Internal Server Error")
    Evoke::Callback.stubs(:post).with('/callbacks', {"url" => "http://good"}).returns(good_response)
    Evoke::Callback.stubs(:post).with('/callbacks', {"url" => "http://bad"}).returns(bad_response)
    Evoke::Callback.stubs(:post).with('/callbacks', {"url" => "http://unknown"}).returns(unknown_response)
  end

  context "with valid data" do
    setup do
      callback = Evoke::Callback.new("url" => "http://good")
      callback.save
      callback
    end

    asserts("url is populated from returned values") { topic.url }.equals("http://foo.bar")
  end # with valid data

  context "with invalid data" do
    setup { Evoke::Callback.new("url" => "http://bad") }

    should "raise error and include save errors in exception message" do
      topic.save
    end.raises(Evoke::RecordInvalid, ["blah"])
  end # with valid data

  context "with some unknown error code" do
    setup { Evoke::Callback.new("url" => "http://unknown") }

    should "raise and error with 500 response code message" do
      topic.save
    end.raises(Evoke::RecordError, "500 - Internal Server Error")
  end # with valid data
end # creating a callback
