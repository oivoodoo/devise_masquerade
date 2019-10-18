# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require 'devise_masquerade'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rails/test_help'
require 'rspec/rails'
require 'factory_bot'
require 'database_cleaner'

Rails.backtrace_cleaner.remove_silencers!

Dir[File.join(File.dirname(__FILE__), '..', "spec/support/*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), '..', "spec/orm/*.rb")].each {|f| require f}

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers

  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include Warden::Test::Helpers
  config.include FactoryBot::Syntax::Methods
  config.include Authentication

  config.raise_errors_for_deprecations!

  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
