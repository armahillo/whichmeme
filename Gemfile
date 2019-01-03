source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.3.5'
gem 'sass-rails', '~> 5.0'
gem 'font-awesome-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'dotenv-rails'

gem 'paperclip'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# For scraping from Reddit
gem 'snooby'

# Dashboard for managing resources
gem 'activeadmin', github: 'activeadmin'

# User management
gem 'cancancan', '~> 1.10'
gem 'devise'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2', '~> 0.2.2'
gem 'faker' # for anonymizing names

# Use Unicorn as the app server
group :production do
  gem 'unicorn'
end

group :development do
  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-rvm'

  # Quickly generate layouts
  gem 'rails_layout'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'annotate'
  gem 'awesome_print'
end

group :test do
  gem 'database_cleaner'
end
