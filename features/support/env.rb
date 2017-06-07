require 'cucumber/rails'
require 'factory_girl'
require 'database_cleaner'
require 'cucumber/rspec/doubles'

Dir[File.join(File.dirname(__FILE__), '..', '..', "spec/support/*.rb")].each {|f| require f}

ENV["RAILS_ENV"] = "test"

Capybara.default_selector = :css

ActionController::Base.allow_rescue = false

World(FactoryGirl::Syntax::Methods)

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation
Capybara.javascript_driver = :webkit

Before do
  allow_any_instance_of(DeviseController).to receive(:devise_mapping) { Devise.mappings[:user] }
end

