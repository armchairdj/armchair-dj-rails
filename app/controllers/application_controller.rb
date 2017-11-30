class ApplicationController < ActionController::Base
  include HandleErrors

  protect_from_forgery with: :exception

  layout :determine_layout

private

  def determine_layout
    "global"
  end
end
