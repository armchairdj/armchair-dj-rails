# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")

  "https://github.com/#{repo_name}.git"
end

###############################################################################
# CORE.
###############################################################################

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "5.2.0"

# Use Postgres as the database for ActiveRecord
gem "pg"

gem "bootsnap", require: false

gem "facets", require: false

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

###############################################################################
# SERVER.
###############################################################################

# Use Puma as the app server
gem "puma", "~> 3.7"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

###############################################################################
# CSS.
###############################################################################

# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"

# Bourbon CSS toolbox + its offspring.
gem "bourbon"
gem "bitters"
gem "neat"

###############################################################################
# JAVASCRIPT.
###############################################################################

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"

# JavaScript bundler.
gem "webpacker", "~> 3.4"

# JavaScript libraries.
gem "jquery-rails"

###############################################################################
# IMAGES.
###############################################################################

# SVG inliner.
gem "inline_svg"

###############################################################################
# VIEWS.
###############################################################################

# Form renderer.
gem "simple_form"

# Boolean i18n translation.
gem "booletania"

# Markdown parser.
gem "redcarpet"

# International character translator.
gem "unidecoder"

###############################################################################
# API.
###############################################################################

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"

###############################################################################
# EMAIL.
###############################################################################

# Email generator. Inlines CSS and automatically generates text versions from HTML.
gem "premailer-rails"

# HTML parser for premailer-rails.
gem "nokogiri"

###############################################################################
# ACTIVE RECORD EXTENSIONS.
###############################################################################

# Use ActiveModel has_secure_password.
gem "bcrypt"

# Pagination.
gem "kaminari"

# Don't allow empty strings into the database.
gem "nilify_blanks"

# Ordinal ranking.
gem "acts_as_list"

# Tree models.
gem "ancestry"

# Soft deletes.
gem "discard"

# Acts As State Machine.
gem "aasm"

# Date validation.
gem "validates_timeliness", '~> 4.0'

# Join scopes into one query.
gem "active_record_union"

# Friendly URLs.
gem "friendly_id"

###############################################################################
# UTILITIES.
###############################################################################

# Configuration factory.
gem "simpleconfig"

# HTTP client library.
gem "faraday"

# Test data.
gem "ffaker"

###############################################################################
# AUTHENTICATION & AUTHORIZATION.
###############################################################################

# Authentication framework.
gem "devise"

# Authorization framework.
# gem "pundit", path: "/Users/armchairdj/Dropbox/Git/pundit"
gem "pundit", git: "https://github.com/armchairdj/pundit", ref: "22b96acfcd06f48c3267abd03f4d841803f73bb3"

###############################################################################
# DEPLOYMENT.
###############################################################################

# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

###############################################################################
# DEV & TEST.
###############################################################################

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"

  gem "listen", ">= 3.0.5", "< 3.2"

  # Application backgrounder.
  gem "spring"

  gem "spring-watcher-listen", "~> 2.0.0"

  # Procfile-based application runner.
  gem "foreman"

  # Query optimizer.
  gem "bullet"

  gem "rubocop", require: false
  gem "rubocop-rails"
  gem "mry"
end

group :development, :test do
  # Pretty printer.
  gem "awesome_print"

  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # Environment variable loader.
  gem "dotenv-rails"

  # Fixture generator.
  gem "factory_bot_rails"

  # Restore behavior of Rails <5 controller tests (assigns and assert_template).
  gem "rails-controller-testing"

  # RSpec + plugins
  gem "rspec-rails"
  gem "accept_values_for"
  gem "db-query-matchers"
  gem "rspec-collection_matchers"
  gem "rspec-html-matchers"
  gem "shoulda-matchers", git: "https://github.com/thoughtbot/shoulda-matchers", branch: "master"
  gem "pundit-matchers"
  # gem "shoulda-callback-matchers" # Causes pundit-matchers to blow up

  # Adds support for Capybara system testing and selenium driver
  gem "capybara"

  # gem "selenium-webdriver"
end

group :test do
  # Test database maintainer.
  gem "database_cleaner"

  # Manipulate env variables.
  gem "climate_control"

  # Manipulate time.
  gem "timecop"

  # Test coverage measurement tool.
  gem "simplecov", require: false

  # Cache http responses from third parties in specs.
  gem "vcr"
end
