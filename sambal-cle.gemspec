spec = Gem::Specification.new do |s|
  s.name = 'sambal-cle'
  s.version = '0.1.6'
  s.summary = %q{rSmart's test framework for testing Sakai-CLE}
  s.description = %q{This gem is used for creating test scripts for the Sakai Collaborative Learning Environment.}
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*test_rb")
  s.authors = ["Abraham Heward", "Jon Utter"]
  s.email = %w{"aheward@rsmart.com" "jutter@rsmart.com"}
  s.homepage = 'https://github.com/rSmart'
  s.add_dependency 'test-factory', '>= 0.0.7'
  s.required_ruby_version = '>= 1.9.2'
end