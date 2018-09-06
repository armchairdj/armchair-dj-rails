# frozen_string_literal: true

# Module to include or extend when you want to call URL helpers
# or polymorphic route helpers in Plain Old Ruby Objects.
# - include to use in instance interface.
# - extend to use in class interface.

module UrlHelpers
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  def default_url_options
    ActionController::Base.default_url_options
  end
end
