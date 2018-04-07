class ApplicationController < ActionController::Base
  include Pundit

  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index

  include Errorable

  protect_from_forgery with: :exception

  layout :determine_layout

  add_flash_types :error, :success, :info

private

  def determine_layout
    @crud ? "crud" : "public"
  end

  def is_crud
    @crud = true
  end
end
