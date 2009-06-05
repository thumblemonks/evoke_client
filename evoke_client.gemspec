Gem::Specification.new do |s|
  s.name     = "evoke_client"
  s.version  = "0.1.2"
  s.date     = "2009-05-03"
  s.summary  = "Rest client interface for talking REST to the evoke service"
  s.email    = %w[gus@gusg.us]
  s.homepage = "http://github.com/thumblemonks/evoke_client"
  s.description = "Rest client interface for talking REST to the evoke service"
  s.authors  = %w[Justin\ Knowlden]
  s.post_install_message = %q{Choosy architectonics choose Thumble Monks.}

  s.has_rdoc = false
  s.rdoc_options = ["--main", "README.markdown"]
  s.extra_rdoc_files = ["README.markdown"]

  s.add_dependency("rest-client", [">= 0.9.2"])

  # run git ls-files to get an updated list
  s.files = %w[
    MIT-LICENSE
    README.markdown
    Rakefile
    lib/evoke_client.rb
    lib/query_string.rb
  ]
  
  s.test_files = %w[
    test/evoke_client_test.rb
    test/shoulda_macros/rest_client.rb
    test/test_helper.rb
  ]
end
