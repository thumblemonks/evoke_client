require 'teststrap'

context "create or update" do

  setup do
    @post_response = HTTParty::Response.new({"url" => "http://poster"}, "", 201, "Created")
    @put_response = HTTParty::Response.new({"url" => "http://putter", "guid" => "putter"}, "", 200, "Ok")
  end

  context "when record does not exist" do
    setup do
      Evoke::Callback.stubs(:get).with('/callbacks/poster').returns("")
      Evoke::Callback.expects(:post).with('/callbacks', {"guid" => "poster"}).returns(@post_response)
      Evoke::Callback.create_or_update({"guid" => "poster"})
    end

    should "post to callbacks" do
      topic.url
    end.equals("http://poster")
  end # when record does not exist

  context "when record does exist" do
    setup do
      Evoke::Callback.stubs(:get).with('/callbacks/putter').returns(@put_response)
      Evoke::Callback.expects(:put).with('/callbacks/putter',
        {"url" => "http://putter", "guid" => "putter"}).returns(@put_response)
      Evoke::Callback.create_or_update({"guid" => "putter"})
    end

    should "put to callbacks when record does exist" do
      topic.url
    end.equals("http://putter")
  end # when record does exist
end # create or update
