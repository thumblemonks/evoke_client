require 'teststrap'

context "configuring evoke client" do
  context "with defaults" do
    asserts("base_uri") { Evoke::Callback.base_uri }.equals("http://test:3000")
    asserts("format") { Evoke::Callback.format }.equals(:json)
  end # with defaults

  context "with custom base_uri" do
    setup { Evoke.configure("http://yo.ma.ma:3000/") }
    asserts("base_uri") { Evoke::Callback.base_uri }.equals("http://yo.ma.ma:3000/")
  end
end # configuring evoke client
