require "bundler"
  
Bundler.setup

require "active_model"
require "rspec"
require "humanizer"

I18n.load_path << File.expand_path("../humanizer.en.yml", __FILE__)
