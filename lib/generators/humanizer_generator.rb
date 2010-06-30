class HumanizerGenerator < Rails::Generators::Base  
  LOCALE_FILE = File.join(File.dirname(__FILE__) , "templates", "en.yml")
  
  def add_locale
    template LOCALE_FILE, "config/locales/humanizer.en.yml"
  end
end
