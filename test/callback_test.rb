require File.join(File.dirname(__FILE__), 'test_helper')

context "configuring evoke client" do
  context "with defaults" do
    asserts "base_uri" do
      Evoke::Callback.default_options[:base_uri]
    end.equals("http://evoke.thumblemonks.com")

    asserts("format") { Evoke::Callback.default_options[:format] }.equals(:json)
  end # with defaults

  context "with custom base_uri" do
    setup { Evoke.configure("http://yo.ma.ma:3000/") }

    asserts("base_uri") { Evoke::Callback.default_options[:base_uri] }.equals("http://yo.ma.ma:3000")
  end
end # configuring evoke client

context "finding a callback" do
  setup do
    callback_data = {"url" => "http://foo.bar", "http_method" => "get"}
    Evoke::Callback.stubs(:get).with('/callbacks/a1b2c3').returns(callback_data)
    Evoke::Callback.stubs(:get).with('/callbacks/blah').returns("")
  end

  context "that exists" do
    setup { Evoke::Callback.find('a1b2c3') }
    should("return a Callback object") { topic }.kind_of(Evoke::Callback)
    asserts("url attribute is accessible as method") { topic.url }.equals("http://foo.bar")
    asserts("htt_method attribute is accessible as method") { topic.http_method }.equals("get")
  end

  context "that does not exist" do
    setup { Evoke::Callback.find('blah') }
    asserts("result") { topic }.nil
  end
end # finding a callback

context "creating a callback" do
end # creating a callback

context "updating a callback" do
end # updating a callback

context "destroying a callback" do
end # destroying a callback
