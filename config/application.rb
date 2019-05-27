# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module ArmchairDjRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.time_zone = "Pacific Time (US & Canada)"

    config.autoload_paths += ["#{config.root}/app/models/attributions"]
    config.autoload_paths += ["#{config.root}/app/models/posts"]
    config.autoload_paths += ["#{config.root}/app/models/works"]

    # config.active_storage.variant_processor = :vips

    config.generators do |g|
      g.test_framework :rspec
      g.helper_specs true
      g.controller_specs true
      g.view_specs true
      g.routing_specs true
      g.request_specs false
      g.system_specs true # Does not work
      g.javascripts false
      g.scaffold_stylesheet false
      g.stylesheets false
      g.helper true
      g.pundit true
      g.scaffold_controller :scaffold_controller_with_pundit
    end

    # Custom error pages.
    config.exceptions_app = self.routes

    # Raise errors on non-whitelisted mass-assignment params.
    config.action_controller.action_on_unpermitted_parameters = :raise
  end
end
