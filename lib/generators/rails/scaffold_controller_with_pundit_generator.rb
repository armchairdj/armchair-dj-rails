# frozen_string_literal: true

class Rails::ScaffoldControllerWithPunditGenerator < Rails::Generators::ScaffoldControllerGenerator
  class_option :pundit, type: :boolean

  hook_for :pundit, as: :policy
end
