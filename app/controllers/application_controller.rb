class ApplicationController < ActionController::Base
  include Pundit

  include Errorable

  protect_from_forgery with: :exception

  layout :determine_layout

  add_flash_types :error, :success, :info

protected

  def model_class
    @model_class ||= controller_name.classify.constantize
  end

private

  def authorize_collection
    authorize model_class
  end

  def determine_layout
    'public'
  end
end
