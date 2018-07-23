# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
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

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.javascripts false
      g.scaffold_stylesheet false
      g.stylesheets false
      g.system_tests nil
      g.helper true
      g.pundit true
      g.scaffold_controller :scaffold_controller_with_pundit
    end

    # Custom error pages.
    config.exceptions_app = self.routes
  end
end
