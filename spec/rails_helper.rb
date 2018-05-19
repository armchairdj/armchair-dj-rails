# frozen_string_literal: true

require "simplecov"

SimpleCov.start "rails" do
  add_group "Policies", "app/policies"

  add_filter "/src"
  add_filter "/lib/generators"
  add_filter "/lib/templates"
  add_filter "/app/controllers/users"
end

require "spec_helper"

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

# Add additional requires below this line. Rails is not loaded until this point!

require "aasm/rspec"
require "support/factory_bot"
require "vcr"
require "nilify_blanks/matchers"
require "rspec/collection_matchers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include AbstractController::Translation
  config.include Rails.application.routes.url_helpers
  config.include RSpecHtmlMatchers
  config.include InlineSvg::ActionView::Helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include FactoryHelpers, type: :model
  config.include FactoryHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |config|
  config.hook_into :faraday
  config.configure_rspec_metadata!

  config.cassette_library_dir     = "spec/support/cassettes"
  config.default_cassette_options = {
    record: :new_episodes,
    erb:    true
  }

  # To filter credentials from environment variables
  # config.filter_sensitive_data("<GREETING>") { "Hello" }
  # config.filter_sensitive_data("<LOCATION>") { "World" }
end
