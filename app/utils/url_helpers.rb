# Module to include or extend when you want to call URL helpers
# or polymorphic route helpers in Plain Old Ruby Objects.
# - include UrlHelpers to use in instance interface.
# - extend UrlHelpers to use in class interface.

module UrlHelpers
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  def default_url_options
    ActionController::Base.default_url_options
  end
end
