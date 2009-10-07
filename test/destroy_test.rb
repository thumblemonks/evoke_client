require 'teststrap'

context "destroying a callback" do
  context "that actually exists" do
    setup do
      Evoke::HTTMockParty.delete('/callbacks/good').ok
      Evoke::Callback.new("guid" => "good")
    end
    
    asserts("nil is returned from destroy") { topic.destroy }.nil
  end # that actually exists

  context "that causes some failure" do
    setup do
      Evoke::HTTMockParty.delete('/callbacks/bad').responds({"errors" => ["sucka"]}).unprocessable_entity
      Evoke::Callback.new("guid" => "bad")
    end
    
    asserts "error is raised with errors in exception message" do
      topic.destroy
    end.raises(Evoke::RecordInvalid, ["sucka"])
  end # that causes some failure

  context "that does not exist" do
    setup do
      Evoke::HTTMockParty.delete('/callbacks/what').not_found
      Evoke::Callback.new("guid" => "what")
    end
    
    should("raise an error") { topic.destroy }.raises(Evoke::RecordNotFound)
  end # that does not exist
end # destroying a callback
