class RateableGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template            'model.rb', 'app/models/rating.rb'
      
      unless options[:skip_migration]
        m.migration_template  'migration.rb', 'db/migrate', :migration_file_name => 'create_ratings'
      end
    end
  end
  
protected
  def add_option!(opt)
    opt.seperator ''
    opt.seperator 'Options'
    opt.on("--skip-migration",
      "Don't generate a migration file for this model")           { |v| options[:skip_migration] = false }
  end
end
