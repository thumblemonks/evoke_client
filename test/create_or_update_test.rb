require 'teststrap'

context "create or update" do

  context "when callback does not exist" do
    setup do
      Evoke::HTTMockParty.get('/callbacks/poster').not_found
      Evoke::HTTMockParty.post('/callbacks', :query => {"guid" => "poster"}).
        responds({"url" => "http://poster"}).created
      Evoke::Callback.create_or_update({"guid" => "poster"})
    end

    should "post to callbacks and update itself accordingly" do
      topic.url
    end.equals("http://poster")
  end # when callback does not exist

  context "when callback does exist" do
    setup do
      Evoke::HTTMockParty.get('/callbacks/putter').
        responds({"url" => "http://putter", "guid" => "putter"}).ok
      Evoke::HTTMockParty.put('/callbacks/putter',
          :query => {"guid" => "putter", "url" => "http://putter.back"}).
        responds({"url" => "http://putter.new"}).ok
      Evoke::Callback.create_or_update({"guid" => "putter", "url" => "http://putter.back"})
    end
  
    should "put to callbacks and update itself accordingly" do
      topic.url
    end.equals("http://putter.new")
  end # when callback does exist

end # create or update
