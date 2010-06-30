class HumanizerGenerator < Rails::Generators::Base  
  source_root File.expand_path("../templates/locales", __FILE__)
  argument :selected_locales, :type => :array, :default => ["en"], :banner => "en fi de"
  desc "Adds locales for Humanizer to your Rails application.\nBy default it will only add English."
  class_option :"show-locales", :desc => "Print all available locales", :type => :boolean
  class_option :"all-locales", :desc => "Install all available locales", :type => :boolean
  
  def add_locales
    if options["show-locales"]
      puts "Available locales:\n" +
           "  - " + available_locales.sort.join("\n  - ")
    else
      if options["all-locales"]
        install_locales(available_locales)
      else
        check_locales!
        install_locales(selected_locales)
      end
    end
  end
  
  private
  
  def available_locales
    Dir.glob(File.join(self.class.source_root, "*.yml")).map do |path|
      path.match(/([\w-]+)\.yml$/)[1]
    end
  end
  
  def check_locales!
    unknown_locales = []
    selected_locales.each do |locale|
      unknown_locales << locale unless available_locales.include?(locale)
    end
    
    if unknown_locales.any?
      abort "The following locales do not exist: \n" +
            "  - " + unknown_locales.join("\n  - ") + "\n\n" +
            "The available locales are: " +
            available_locales.sort.join(", ")
    end
  end
  
  def install_locales(locales)
    locales.each do |locale|
      copy_file "#{locale}.yml", "config/locales/humanizer.#{locale}.yml"
    end
  end
end
