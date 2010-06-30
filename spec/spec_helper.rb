require "rubygems"
require "bundler"
  
Bundler.setup
Bundler.require

require "rails"
require "active_model"

I18n.load_path << File.expand_path("../humanizer.en.yml", __FILE__)