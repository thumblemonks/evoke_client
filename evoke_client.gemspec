Gem::Specification.new do |s|
  s.name     = "evoke_client"
  s.version  = "0.2.0"
  s.date     = "2009-10-03"
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

  s.files = %w[
    MIT-LICENSE
    README.markdown
    Rakefile
    evoke_client.gemspec
    lib/evoke_client.rb
  ]
  
  s.test_files = %w[
    test/callback_test.rb
    test/test_helper.rb
  ]
end
