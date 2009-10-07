require 'teststrap'

context "create or update" do

  context "when callback does not exist" do
    setup do
      Evoke::HTTMockParty.get('/callbacks/poster').ok
      Evoke::HTTMockParty.post('/callbacks', {"guid" => "poster"}).
        responds({"url" => "http://poster"}).created
      Evoke::Callback.create_or_update({"guid" => "poster"})
    end

    should "post to callbacks and update itself accordingly" do
      topic.url
    end.equals("http://poster")
  end # when callback does not exist

  context "when callback does exist" do
    setup do
      put_response = {"url" => "http://putter", "guid" => "putter"}
      Evoke::HTTMockParty.get('/callbacks/putter').responds(put_response).ok
      Evoke::HTTMockParty.put('/callbacks/putter', put_response).
        responds({"url" => "http://putter.new"}).ok
      Evoke::Callback.create_or_update({"guid" => "putter"})
    end
  
    should "put to callbacks and update itself accordingly" do
      topic.url
    end.equals("http://putter.new")
  end # when callback does exist

end # create or update
