class RateableGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template            'model.rb', 'app/models/rating.rb'
      
      unless options[:skip_migration]
        m.migration_template  'migration.rb', 'db/migrate', :migration_file_name => 'create_ratings'
      end
      
      unless options[:skip_five_star]
        m.template  'stylesheet.css',   'public/stylesheets/rating.css'
        m.template  'star-matrix.gif',  'public/images/star-matrix.gif'
      end
    end
  end
  
protected
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options'
    opt.on("--skip-migration",
      "Don't generate a migration file for this model")                 { |v| options[:skip_migration] = false }
    opt.on("--skip-five-star",
      "Don't generate the images and style for the star rating system") { |v| options[:skip_five_star] = false }
    opt.on("--by-user",
      "Generate and display ratings per user")                          { |v| options[:by_user] = true }
  end
end
