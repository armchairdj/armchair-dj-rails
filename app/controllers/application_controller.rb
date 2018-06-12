# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  include Errorable

  prepend_before_action :model_class

  protect_from_forgery with: :exception

  layout :determine_layout

  add_flash_types :error, :success, :info

protected

  def model_class
    @model_class ||= controller_name.classify.constantize
  rescue NameError => e
    @model_class = nil
  end

  def after_sign_in_path_for(user)
    if (requested_page = session.delete("user_return_to")).present?
      requested_page
    elsif user.can_write?
      admin_articles_path
    else
      posts_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    posts_path
  end

private

  def authorize_model
    authorize model_class
  end

  def determine_layout
    "public"
  end
end
