Gem::Specification.new do |s|
  s.name     = "evoke_client"
  s.version  = "0.2.3"
  s.date     = "2009-10-08"
  s.summary  = "Tool for interfacing with the Evoke web service"
  s.email    = %w[gus@gusg.us]
  s.homepage = "http://github.com/thumblemonks/evoke_client"
  s.description = "Tool for interfacing with the Evoke web service. See http://github.com/thumblemonks/evoke"
  s.authors  = %w[Justin\ Knowlden]
  s.post_install_message = %q{Choosy wizards choose Thumble Monks.}

  s.has_rdoc = false
  s.rdoc_options = ["--main", "README.markdown"]
  s.extra_rdoc_files = ["README.markdown"]

  s.add_dependency("httparty", [">= 0.4.4"])
  s.add_development_dependency("riot", [">= 0.9.6"])

  s.files = %w[
    MIT-LICENSE
    README.markdown
    evoke_client.gemspec
    lib/evoke_client.rb
    lib/evoke_client/base.rb
    lib/evoke_client/mash.rb
    lib/evoke_client/mock.rb
  ]

  s.test_files = %w[
    Rakefile
    test/callback_test.rb
    test/configuration_test.rb
    test/create_or_update_test.rb
    test/create_test.rb
    test/destroy_test.rb
    test/find_test.rb
    test/teststrap.rb
    test/update_test.rb
  ]
end
