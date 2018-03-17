class ApplicationController < ActionController::Base
  include Pundit
  include Errorable

  protect_from_forgery with: :exception

  layout :determine_layout

  add_flash_types :error, :success, :info

private

  def determine_layout
    "global"
  end
end
