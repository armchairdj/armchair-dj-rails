# frozen_string_literal: true

module Stimulus
  class ControllerGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    desc "This generator creates a new stimulus controller in app/javascripts/controllers"

    def create_controller_file
      copy_file "controller.js", "app/javascript/controllers/#{file_name}_controller.js"
    end
  end
end
