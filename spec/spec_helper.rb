require "active_model"
require "rspec"
require "humanizer"

I18n.load_path << File.expand_path("../humanizer.en.yml", __FILE__)

def with_locale(locale)
  old_locale = I18n.locale
  I18n.locale = locale
  yield
ensure
  I18n.locale = old_locale
end
