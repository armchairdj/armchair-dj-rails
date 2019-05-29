# frozen_string_literal: true

module Rails
  class ScaffoldControllerWithPunditGenerator < Rails::Generators::ScaffoldControllerGenerator
    class_option :pundit, type: :boolean

    hook_for :pundit, as: :policy
  end
end
