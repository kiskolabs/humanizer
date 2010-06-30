require File.expand_path("../lib/humanizer/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "humanizer"
  s.version     = Humanizer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Antti Akonniemi", "Joao Carlos Cardoso"]
  s.email       = ["antti@kiskolabs.com", "joao@kiskolabs.com"]
  s.homepage    = "http://github.com/kiskolabs/humanizer"
  s.summary     = "A really simple captcha solution"
  s.description = "Recaptcha was too much for us, so we created this. Shout-out to brain_busters"

  s.required_rubygems_version = ">= 1.3.6"

  s.rubyforge_project         = "humanizer"

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md", "lib/generators/**/*.*"]
  s.require_path = 'lib'
end