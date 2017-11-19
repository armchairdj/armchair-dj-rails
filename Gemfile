source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")

  "https://github.com/#{repo_name}.git"
end

###############################################################################
# CORE.
###############################################################################

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'

# Use Postgres as the database for Active Record
gem 'pg'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

###############################################################################
# SERVER.
###############################################################################

# Use Puma as the app server
gem 'puma', '~> 3.7'

###############################################################################
# CSS.
###############################################################################

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# SASS/UI framework
gem 'foundation-rails', '~> 6.4'

# SASS and CSS libraries.
gem 'normalize-rails'

###############################################################################
# JAVASCRIPT.
###############################################################################

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# JavaScript libraries.
gem 'jquery-rails'

###############################################################################
# VIEWS.
###############################################################################

gem 'simple_form'

###############################################################################
# UTILITIES.
###############################################################################

# Configuration factory.
gem 'simpleconfig'

# Don't allow empty strings into the database
gem 'nilify_blanks'

# HTTP client library.
gem 'faraday'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

###############################################################################
# DEV & TEST.
###############################################################################

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Environment variable loader.
  gem 'dotenv-rails'

  # Restore behavior of Rails <5 controller tests (assigns and assert_template).
  gem 'rails-controller-testing'

  # Rspec + plugins
  gem 'rspec-rails'
  gem 'rspec-html-matchers'
  gem 'shoulda-matchers'
  # gem 'shoulda-callback-matchers' # Causes pundit-matchers to blow up
  gem 'pundit-matchers'
  gem 'accept_values_for'

  # Fixture generator.
  gem 'factory_bot_rails'

  # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '~> 2.13'

  # gem 'selenium-webdriver'
end

group :test do
  # Test database maintainer.
  gem 'database_cleaner'

  # Time manipulation tool.
  gem 'timecop'

  # Test coverage measurement tool.
  gem 'simplecov'

  # Cache http responses from third parties in specs.
  gem 'vcr'

  # Modify environment variables in specs.
  gem 'climate_control'
end
