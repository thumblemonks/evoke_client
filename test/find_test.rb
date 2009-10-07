require 'test_helper'

context "finding a callback" do
  setup do
    good_data = {"url" => "http://foo.bar", "http_method" => "get"}
    good_response = HTTParty::Response.new(good_data, "", 200, "Ok")
    not_found_response = HTTParty::Response.new("", "", 404, "Not Found")
    Evoke::Callback.stubs(:get).with('/callbacks/a1b2c3').returns(good_response)
    Evoke::Callback.stubs(:get).with('/callbacks/blah').returns(not_found_response)
  end

  context "that exists" do
    setup { Evoke::Callback.find('a1b2c3') }
    should("return a Callback object") { topic }.kind_of(Evoke::Callback)
    asserts("url attribute is accessible as method") { topic.url }.equals("http://foo.bar")
    asserts("http_method attribute is accessible as method") { topic.http_method }.equals("get")
    should("not be a new record") { !topic.new_record? }
  end

  context "that does not exist" do
    setup { Evoke::Callback.find('blah') }
    asserts("result") { topic }.nil
  end
end # finding a callback
