require 'teststrap'

context "updating a callback" do
  setup do
    good_response = HTTParty::Response.new({"url" => "http://foo.bar"}, "", 200, "Ok")
    bad_response = HTTParty::Response.new({"errors" => ["mutha"]}, "", 422, "Unprocessable Entity")
    not_found_response = HTTParty::Response.new("", "", 404, "Not Found")
    Evoke::Callback.stubs(:put).with('/callbacks/good', anything).returns(good_response)
    Evoke::Callback.stubs(:put).with('/callbacks/bad', anything).returns(bad_response)
    Evoke::Callback.stubs(:put).with('/callbacks/what', anything).returns(not_found_response)
  end

  context "that actually exists" do
    setup do
      callback = Evoke::Callback.new("guid" => "good", "url" => "http://a.b", :new_record => false)
      callback.save
      callback
    end
    
    asserts("url is updated from results") { topic.url }.equals("http://foo.bar")
  end # that actually exists

  context "that causes some failure" do
    setup { callback = Evoke::Callback.new("guid" => "bad", :new_record => false) }
    should("raise an error") { topic.save }.raises(Evoke::RecordInvalid)
    should("include errors in exception message") { topic.save }.raises(Evoke::RecordInvalid, "mutha")
  end # that causes some failure

  context "that does not exist" do
    setup { Evoke::Callback.new("guid" => "what", :new_record => false) }
    should("raise an error") { topic.save }.raises(Evoke::RecordNotFound)
  end # that does not exist
end # updating a callback
