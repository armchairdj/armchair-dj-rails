# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")

  "https://github.com/#{repo_name}.git"
end

ruby "2.6.3"

###############################################################################
# CORE.
###############################################################################

gem "rails", "5.2.3"

# Required for Rails console.
gem "rb-readline"

# Postgres for ActiveRecord.
gem "pg"

# Server optimizer.
gem "bootsnap", require: false

# Ruby utilities.
gem "facets", require: false

###############################################################################
# SERVER.
###############################################################################

# Use Puma as the app server
gem "puma", "~> 3.12.1"

###############################################################################
# PLUMBING.
###############################################################################

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

###############################################################################
# ACTIVE STORAGE.
###############################################################################

# AWS S3.
gem "aws-sdk-s3", require: false

# Image resizing.
gem "image_processing", "~> 1.9"

# Validations
gem "active_storage_validations"

###############################################################################
# ACCESS CONTROLE.
###############################################################################

# Authentication.
gem "devise"

# Authorization.
# gem "pundit", path: "/Users/armchairdj/Dropbox/Git/pundit"
gem "pundit", github: "armchairdj/pundit", ref: "22b96acfcd06f48c3267abd03f4d841803f73bb3"

###############################################################################
# MODELS.
###############################################################################

# ActiveModel has_secure_password.
gem "bcrypt"

# Ban-hammer for empty strings in the database.
gem "nilify_blanks"

# Ordered collections.
gem "acts_as_list"

# Tree models.
# gem "ancestry"

# Soft deletes.
gem "discard"

# Date validation.
gem "validates_timeliness", "~> 4.0"

# Join scopes into one query.
gem "active_record_union"

# Friendly URL slugs (requires unidecoder).
gem "friendly_id"
gem "unidecoder"

###############################################################################
# CONTROLLERS.
###############################################################################

# Declarative controller interfaces.
gem "decent_exposure"

# DRY format responders.
gem "responders"

# State machines.
gem "aasm", "~> 5.0"

# Pagination.
gem "kaminari"

###############################################################################
# VIEWS.
###############################################################################

# Form renderer.
gem "simple_form"

# Boolean i18n translation.
gem "booletania"

# Markdown parser.
gem "redcarpet"

# JSON response builder.
gem "jbuilder", "~> 2.5"

###############################################################################
# STYLESHEETS.
###############################################################################

# Use SCSS for stylesheets
gem "sassc-rails"

# Bourbon CSS toolbox + its offspring.
gem "bourbon"
gem "bitters"
gem "neat"

###############################################################################
# JAVASCRIPTS.
###############################################################################

# JS bundler.
gem "webpacker", "~> 4.0"

# JS compresser.
gem "uglifier", ">= 1.3.0"

# Fast page loads.
gem "turbolinks", "~> 5.2.0"

# jQuery.
gem "jquery-rails"

# Run JavaScript from within Ruby.
# gem "therubyracer", platforms: :ruby

###############################################################################
# IMAGES.
###############################################################################

# SVG inliner.
gem "inline_svg"

###############################################################################
# EMAIL.
###############################################################################

# Email generator. Inlines CSS and automatically generates text versions from HTML.
gem "premailer-rails"

# HTML parser for premailer-rails.
gem "nokogiri"

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

  # File-change notifier.
  gem "listen", ">= 3.0.5", "< 3.2"

  # Application backgrounder.
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring-commands-rspec"

  # Procfile-based application runner.
  gem "foreman"

  # Query optimizer.
  gem "bullet", "~> 5.9.0"

  # Automatic route and schema comments in model files.
  gem "annotate"
end

group :development, :test do
  # Restore behavior of Rails <5 controller tests (assigns and assert_template).
  gem "rails-controller-testing"

  # Declarative fixtures.
  gem "factory_bot_rails"

  # Fast tests.
  gem "parallel_tests"

  # RSpec.
  gem "rspec-rails", "~> 3.7.2"

  # RSpec plugins.
  gem "accept_values_for"
  gem "db-query-matchers"
  gem "pundit-matchers"
  gem "rspec-collection_matchers"
  gem "rspec-html-matchers"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers", github: "thoughtbot/shoulda-matchers", branch: "master"
  gem "shoulda-callback-matchers"

  # System and JS specs.
  gem "capybara"
  gem "webdrivers"

  # Environment variable loader.
  gem "dotenv-rails"

  # Pretty printer.
  gem "awesome_print"

  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # Static code analysis.
  gem "rubocop", "~> 0.65.0", require: false
  gem "rubocop-rails_config"
  gem "rubocop-rspec"
  gem "mry"
end

group :test do
  # Test database maintainer.
  gem "database_cleaner"

  # Manipulate environment variables.
  gem "climate_control"

  # Manipulate time.
  gem "timecop"

  # Measure spec coverage.
  gem "simplecov", require: false

  # Cache exteranl HTTP responses for specs.
  gem "vcr"
end
