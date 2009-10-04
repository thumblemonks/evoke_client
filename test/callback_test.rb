require File.join(File.dirname(__FILE__), 'test_helper')

#
# Configure
#

context "configuring evoke client" do
  context "with defaults" do
    asserts "base_uri" do
      Evoke::Callback.default_options[:base_uri]
    end.equals("http://localhost:3000")

    asserts("format") { Evoke::Callback.default_options[:format] }.equals(:json)
  end # with defaults

  context "with custom base_uri" do
    setup { Evoke.configure("http://yo.ma.ma:3000/") }

    asserts("base_uri") { Evoke::Callback.default_options[:base_uri] }.equals("http://yo.ma.ma:3000")
  end
end # configuring evoke client

#
# Find
#

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

#
# Create
#

context "creating a callback" do
  setup do
    good_response = HTTParty::Response.new({"url" => "http://foo.bar"}, "", 201, "Created")
    bad_response = HTTParty::Response.new({"errors" => ["blah"]}, "", 422, "Unprocessable Entity")
    unknown_response = HTTParty::Response.new("", "", 500, "Internal Server Error")
    Evoke::Callback.stubs(:post).with('/callbacks', {"url" => "http://good"}).returns(good_response)
    Evoke::Callback.stubs(:post).with('/callbacks', {"url" => "http://bad"}).returns(bad_response)
    Evoke::Callback.stubs(:post).with('/callbacks', {"url" => "http://unknown"}).returns(unknown_response)
  end

  context "with valid data" do
    setup do
      callback = Evoke::Callback.new("url" => "http://good")
      callback.save
      callback
    end

    asserts("url is populated from returned values") { topic.url }.equals("http://foo.bar")
  end # with valid data

  context "with invalid data" do
    setup { Evoke::Callback.new("url" => "http://bad") }

    should("raise and error") { topic.save }.raises(Evoke::RecordInvalid)

    should "include save errors in exception message" do
      begin
        topic.save
      rescue Evoke::RecordInvalid => e
        e.message # This should be returned
      end
    end.equals(["blah"])
  end # with valid data

  context "with some unknown error code" do
    setup { Evoke::Callback.new("url" => "http://unknown") }

    should("raise and error") { topic.save }.raises(Evoke::RecordError)

    should "include response code and message as exception message" do
      begin
        topic.save
      rescue Evoke::RecordError => e
        e.message # This should be returned
      end
    end.equals("500 - Internal Server Error")
  end # with valid data
end # creating a callback

#
# Update
#

context "updating a callback" do
  setup do
    good_response = HTTParty::Response.new({"url" => "http://foo.bar"}, "", 200, "Ok")
    bad_response = HTTParty::Response.new({"errors" => ["mutha"]}, "", 422, "Unprocessable Entity")
    not_found_response = HTTParty::Response.new("", "", 404, "Not Found")
    Evoke::Callback.stubs(:put).with('/callbacks/good', anything).returns(good_response)
    Evoke::Callback.stubs(:put).with('/callbacks/bad', anything).returns(bad_response)
    Evoke::Callback.stubs(:put).with('/callbacks/what', anything).returns(not_found_response)
  end

  context "that actually exists" do
    setup do
      callback = Evoke::Callback.new("guid" => "good", "url" => "http://a.b", :new_record => false)
      callback.save
      callback
    end
    
    asserts("url is updated from results") { topic.url }.equals("http://foo.bar")
  end # that actually exists

  context "that causes some failure" do
    setup do
      callback = Evoke::Callback.new("guid" => "bad", :new_record => false)
    end
    
    should("raise an error") { topic.save }.raises(Evoke::RecordInvalid)

    should "include errors in exception message" do
      begin
        topic.save
      rescue Evoke::RecordInvalid => e
        e.message # This should be returned
      end
    end.equals(["mutha"])
  end # that causes some failure

  context "that does not exist" do
    setup do
      callback = Evoke::Callback.new("guid" => "what", :new_record => false)
    end
    
    should("raise an error") { topic.save }.raises(Evoke::RecordNotFound)
  end # that does not exist
end # updating a callback

#
# Destroy
#

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
    
    should("raise an error") { topic.destroy }.raises(Evoke::RecordInvalid)

    should "include errors in exception message" do
      begin
        topic.destroy
      rescue Evoke::RecordInvalid => e
        e.message # This should be returned
      end
    end.equals(["sucka"])
  end # that causes some failure

  context "that does not exist" do
    setup do
      callback = Evoke::Callback.new("guid" => "what")
    end
    
    should("raise an error") { topic.destroy }.raises(Evoke::RecordNotFound)
  end # that does not exist
end # destroying a callback
