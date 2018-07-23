# Module to include or extend when you want to call
# URL helpers or polymorphic route helpers in PORO.
# - include to use in instance methods
# - extend to use in class methods

module UrlHelpers
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  def default_url_options
    ActionController::Base.default_url_options
  end
end
