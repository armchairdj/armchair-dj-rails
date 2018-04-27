# frozen_string_literal: true

class AdminController < ApplicationController
  include SeoPaginatable

  prepend_before_action :is_admin

  after_action :verify_authorized

private

  def determine_layout
    "admin"
  end

  def is_admin
    @admin = true
  end

  def scoped_and_sorted_collection
    @page  = params[:page]
    @scope = (params[:scope] || model_class.default_admin_scope).to_sym

    raise Pundit::NotAuthorizedError unless model_class.admin_scopes.values.include? @scope

    policy_scope(model_class).send(@scope).page(@page)
  end
end
