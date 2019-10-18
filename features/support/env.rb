require 'cucumber/rails'
require 'factory_bot'
require 'database_cleaner'
require 'cucumber/rspec/doubles'

Dir[File.join(File.dirname(__FILE__), '..', '..', "spec/support/*.rb")].each {|f| require f}

ENV["RAILS_ENV"] = "test"

Capybara.default_selector = :css

ActiveSupport.on_load(:action_controller) do
  self.allow_rescue = false
end

World(FactoryBot::Syntax::Methods)

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
  opts = Selenium::WebDriver::Chrome::Options.new

  chrome_args = %w[--headless --window-size=1920,1080 --no-sandbox --disable-dev-shm-usage]
  chrome_args.each { |arg| opts.add_argument(arg) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts, desired_capabilities: caps)
end

Capybara.configure do |config|
  # change this to :chrome to observe tests in a real browser
  config.javascript_driver = :headless_chrome
end

Before do
  allow_any_instance_of(DeviseController).to receive(:devise_mapping) { Devise.mappings[:user] }
end

