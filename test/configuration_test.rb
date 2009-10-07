require 'test_helper'

context "configuring evoke client" do
  context "with defaults" do

    asserts "base_uri" do
      Evoke::Callback.default_options[:base_uri]
    end.equals("http://localhost:3000")

    asserts("format") do
      Evoke::Callback.default_options[:format]
    end.equals(:json)

  end # with defaults

  context "with custom base_uri" do

    setup { Evoke.configure("http://yo.ma.ma:3000/") }

    asserts("base_uri") do
      Evoke::Callback.default_options[:base_uri]
    end.equals("http://yo.ma.ma:3000")

  end
end # configuring evoke client
