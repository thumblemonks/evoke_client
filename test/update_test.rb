require 'teststrap'

context "updating a callback" do

  context "that actually exists" do
    setup do
      Evoke::HTTMockParty.put('/callbacks/good', :query => {"guid" => "good", "url" => "http://a.b"}).
        responds({"url" => "http://foo.bar"}).ok
      callback = Evoke::Callback.new("guid" => "good", "url" => "http://a.b", :new_record => false)
      callback.save
      callback
    end
    
    asserts("url is updated from results") { topic.url }.equals("http://foo.bar")
  end # that actually exists

  context "that causes some failure" do
    setup do
      Evoke::HTTMockParty.put('/callbacks/bad', :query => {"guid" => "bad"}).
        responds({"errors" => ["mutha"]}).unprocessable_entity
      Evoke::Callback.new("guid" => "bad", :new_record => false)
    end

    should("raise an error") { topic.save }.raises(Evoke::RecordInvalid)
    should("include errors in exception message") { topic.save }.raises(Evoke::RecordInvalid, "mutha")
  end # that causes some failure

  context "that does not exist" do
    setup do
      Evoke::HTTMockParty.put('/callbacks/what', :query => {"guid" => "what"}).not_found
      Evoke::Callback.new("guid" => "what", :new_record => false)
    end

    should("raise an error") { topic.save }.raises(Evoke::RecordNotFound)
  end # that does not exist

end # updating a callback
