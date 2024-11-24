# frozen_string_literal: true
 
source 'https://rubygems.org'

ruby '3.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.1.5'

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors'

# Use dotenv to load environment variables from .env
gem 'dotenv-rails'

# Sidekiq is a simple, efficient background processing for Ruby
gem 'sidekiq'

# Use Redis as the backend for Active Job
gem 'redis'

# NokoGiri is a Ruby gem that is used for HTML and XML parsing
gem 'nokogiri'

# HTTParty is a Ruby gem that is used for making HTTP requests
gem 'httparty'

# Selenium WebDriver is a web automation framework that allows
gem 'selenium-webdriver'

# Bunny is a RabbitMQ Ruby client
gem 'bunny'

# Sidekiq Cron is a simple job scheduler extension for Sidekiq
gem 'sidekiq-cron'

# Webdrivers is a Ruby gem that helps to download and install the latest version of WebDriver binaries
# gem 'webdrivers'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'database_cleaner'
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rswag'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end
