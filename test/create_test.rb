require 'teststrap'

context "creating a callback" do

  context "with valid data" do
    setup do
      good_response = {"url" => "http://foo.bar"}
      Evoke::HTTMockParty.post('/callbacks', {"url" => "http://good"}).responds(good_response).created
      callback = Evoke::Callback.new("url" => "http://good")
      callback.save
      callback
    end

    asserts("url is populated from returned values") do
      topic.url
    end.equals("http://foo.bar")

  end # with valid data

  context "with invalid data" do

    setup do
      bad_response = {"errors" => ["blah"]}
      Evoke::HTTMockParty.post('/callbacks', {"url" => "http://bad"}).
        responds(bad_response).unprocessable_entity
      Evoke::Callback.new("url" => "http://bad")
    end

    should "raise error and include save errors in exception message" do
      topic.save
    end.raises(Evoke::RecordInvalid, ["blah"])

  end # with valid data

  context "with some unknown error code" do

    setup do
      Evoke::HTTMockParty.post('/callbacks', {"url" => "http://unknown"}).internal_server_error
      Evoke::Callback.new("url" => "http://unknown")
    end

    should "raise and error with 500 response code message" do
      topic.save
    end.raises(Evoke::RecordError, "500 - Internal Server Error")

  end # with valid data
end # creating a callback
