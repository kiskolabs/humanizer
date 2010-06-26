class HumanizerGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  LOCALE_FILE = File.join(File.dirname(__FILE__) , "templates", "en.yml")
  MIGRATIONS_FILE = File.join(File.dirname(__FILE__) , "templates", "create_humanizer_questions.rb")
  
  def add_my_initializer
    template LOCALE_FILE, "config/locales/humanizer.en.yml"

  end

  class_option :"skip-migration", :type => :boolean, :desc => "Don't generate a migration for the humanizer questions table"

  def copy_files(*args)
    migration_template MIGRATIONS_FILE, "db/migrate/create_humanizer_questions.rb" unless options["skip-migration"]
  end

  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
  
end
