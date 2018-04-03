require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module ArmchairDjRails
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators do |g|
      g.javascripts false
      g.scaffold_stylesheet false
      g.stylesheets false
      g.system_tests nil
      g.helper false
      g.pundit true
      g.scaffold_controller :scaffold_controller_with_pundit
    end

    # Custom error pages.
    config.exceptions_app = self.routes

    # Make my helpers available in Administrate.
    config.to_prepare do
      Administrate::ApplicationController.helper ArmchairDjRails::Application.helpers
    end
  end
end