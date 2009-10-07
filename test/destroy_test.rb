require 'test_helper'

context "destroying a callback" do
  setup do
    good_response = HTTParty::Response.new("", "", 200, "Ok")
    bad_response = HTTParty::Response.new({"errors" => ["sucka"]}, "", 422, "Unprocessable Entity")
    not_found_response = HTTParty::Response.new("", "", 404, "Not Found")
    Evoke::Callback.stubs(:delete).with('/callbacks/good').returns(good_response)
    Evoke::Callback.stubs(:delete).with('/callbacks/bad').returns(bad_response)
    Evoke::Callback.stubs(:delete).with('/callbacks/what').returns(not_found_response)
  end

  context "that actually exists" do
    setup do
      callback = Evoke::Callback.new("guid" => "good")
      callback.destroy
    end
    
    asserts("nil is returned from destroy") { topic }.nil
  end # that actually exists

  context "that causes some failure" do
    setup do
      callback = Evoke::Callback.new("guid" => "bad")
    end
    
    asserts "error is raised with errors in exception message" do
      topic.destroy
    end.raises(Evoke::RecordInvalid, ["sucka"])
  end # that causes some failure

  context "that does not exist" do
    setup do
      callback = Evoke::Callback.new("guid" => "what")
    end
    
    should("raise an error") { topic.destroy }.raises(Evoke::RecordNotFound)
  end # that does not exist
end # destroying a callback
