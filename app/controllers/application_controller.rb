class ApplicationController < ActionController::Base
  include Pundit

  after_action :verify_authorized, unless: :devise_controller?

  include Errorable

  protect_from_forgery with: :exception

  layout :determine_layout

  add_flash_types :error, :success, :info

private

  def determine_layout
    @admin ? "admin" : "public"
  end

  def is_admin
    @admin = true
  end
end
