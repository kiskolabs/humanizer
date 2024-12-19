# encoding: UTF-8
require File.expand_path("../lib/humanizer/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "humanizer"
  s.version     = Humanizer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Antti Akonniemi", "Joao Carlos Cardoso", "Matias Korhonen", "Vesa Vänskä"]
  s.email       = ["antti@kiskolabs.com", "joao@kiskolabs.com", "matias@kiskolabs.com", "vesa@kiskolabs.com"]
  s.homepage    = "http://github.com/kiskolabs/humanizer"
  s.summary     = "A really simple captcha solution"
  s.description = "reCAPTCHA was too much for us, so we created this. Simplest captcha ever."
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.3.6"

  s.rubyforge_project         = "humanizer"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.6.0"
  s.add_development_dependency "activemodel", ">= 3.0.0"

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md", "lib/generators/**/*.*"]
  s.require_path = 'lib'
end
