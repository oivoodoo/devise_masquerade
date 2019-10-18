ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::MigrationContext.
  new(
    File.expand_path("../../dummy/db/migrate/", __FILE__),
    ActiveRecord::Base.connection.schema_migration
  ).migrate
