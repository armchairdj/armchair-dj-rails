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
    end

    config.exceptions_app = self.routes
  end
end
