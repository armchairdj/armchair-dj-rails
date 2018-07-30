# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module ArmchairDjRails
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.time_zone = "Pacific Time (US & Canada)"

    config.autoload_paths += %W(#{config.root}/lib/utilities)
    config.autoload_paths += %W(#{config.root}/app/models/posts)
    config.autoload_paths += %W(#{config.root}/app/models/works)

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
  end
end
