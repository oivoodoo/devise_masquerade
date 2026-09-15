source 'https://rubygems.org'

# Specify your gem's dependencies in devise_masquerade.gemspec
gemspec

group :test do
  gem 'activerecord', '>= 8.0.5.1'
  gem 'actionmailer', '>= 8.0.5.1'
  gem 'bson_ext', '~> 1.3'
  gem 'sqlite3', '>= 2.9.6'

  gem 'test-unit'

  gem 'pry'
  gem 'pry-byebug'

  gem 'guard'
  gem 'guard-rspec', '~> 4.7'
  gem 'guard-bundler'
  gem 'guard-cucumber'

  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 8.0.4'

  gem 'shoulda'
  gem 'rb-fsevent'
  gem 'factory_bot_rails', '>= 6.5.1'
  gem 'database_cleaner', '>= 2.0.0'
  gem 'cucumber'
  gem 'capybara', '>= 3.38.0'
  gem 'chromedriver-helper'

  gem 'cucumber-rails', '>= 4.0.0'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  gem 'launchy'

  # Dependabot security pins for the dummy/test lockfile.
  # Runtime gemspec constraints stay looser so apps can upgrade independently.
  gem 'devise', '>= 5.0.4'
  gem 'nokogiri', '>= 1.19.3'
  gem 'rack', '>= 3.2.6'
  gem 'rack-session', '>= 2.1.2'
  gem 'net-imap', '>= 0.6.4'
  gem 'erb', '>= 6.0.4'
  gem 'concurrent-ruby', '>= 1.3.7'
  gem 'addressable', '>= 2.9.0'
  gem 'mail', '>= 2.9.1'
  gem 'loofah', '>= 2.25.2'
  gem 'rails-html-sanitizer', '>= 1.7.1'
  gem 'bcrypt', '>= 3.1.22'
  gem 'uri', '>= 1.0.4'
  gem 'rexml', '>= 3.4.2'
  # json 3.0 made JSON.parse kwargs-only; activesupport 8.1.3.1 still
  # passes a positional options hash (rails/rails#58601).
  gem 'json', '>= 2.10', '< 3'
end
