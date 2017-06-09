require "active_model"
require "rspec"
require "humanizer"
require "pry-byebug"

I18n.load_path << File.expand_path("../humanizer.en.yml", __FILE__)
I18n.load_path << File.expand_path("../humanizer.empty.yml", __FILE__)
