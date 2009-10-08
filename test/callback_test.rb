require 'teststrap'

context "initializing a new callback" do
  setup do
    Evoke::Callback.new("url" => "foo", :guid => "papa")
  end

  asserts("url is accessible from a string key") { topic.url }.equals("foo")
  asserts("guid is accessible from a symbolized key") { topic.guid }.equals("papa")
end

context "updating attributes of a callback" do
  setup do
    callback = Evoke::Callback.new("guid" => "meme", "url" => "http://foo.bar", "http_method" => "get")
    callback.update_attributes("guid" => "mom", :url => "http://a.b")
    callback
  end

  asserts("guid updated from a string key") { topic.guid }.equals("mom")
  asserts("url updated form a symbolized key") { topic.url }.equals("http://a.b")
  asserts("http_method is unchanged") { topic.http_method }.equals("get")
end # updating attributes of a callback
