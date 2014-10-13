source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '4.1.5'
gem 'pg'
gem 'warden-github-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'momentjs-rails'
gem 'bootstrap-daterangepicker-rails', :git => 'https://github.com/dannyfallon/bootstrap-daterangepicker-rails.git'

gem 'aws-sdk'
gem 'httparty'
gem 'pry-rails'

group :production do
  gem 'rails_12factor', require: false
end

group :development do
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'metric_fu'
end

group :test do
  gem 'simplecov', require: false
  gem 'coveralls', require: false
end
