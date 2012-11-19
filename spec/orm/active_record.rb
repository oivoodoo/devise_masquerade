ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::Migrator.migrate(File.expand_path("../dummy/db/migrate/", __FILE__))

