require 'teststrap'

context "finding a callback" do
  context "that exists" do
    setup do
      good_data = {"url" => "http://foo.bar", "http_method" => "get"}
      Evoke::HTTMockParty.get('/callbacks/a1b2c3').responds(good_data).ok
      Evoke::Callback.find('a1b2c3')
    end

    should("return a Callback object") { topic }.kind_of(Evoke::Callback)
    should("not be a new record") { !topic.new_record? }

    asserts("url attribute is accessible as method") do
      topic.url
    end.equals("http://foo.bar")

    asserts("http_method attribute is accessible as method") do
      topic.http_method
    end.equals("get")
  end

  context "that does not exist" do
    setup do
      Evoke::HTTMockParty.get('/callbacks/blah').not_found
      Evoke::Callback.find('blah')
    end

    asserts("result") { topic }.nil
  end
end # finding a callback
