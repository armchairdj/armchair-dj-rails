# frozen_string_literal: true

class AdminController < ApplicationController
  include SeoPaginatable

  after_action :verify_authorized

private

  def determine_layout
    "admin"
  end

  def scoped_and_sorted_collection
    @scope = params[:scope].try(:to_sym) || model_class.default_admin_scope
    @sort  = params[:sort]               || model_class.default_admin_sort
    @page  = params[:page]

    unless model_class.allowed_admin_scope?(@scope)
      raise Pundit::NotAuthorizedError, "Unknown scope param [#{@scope}]."
    end

    unless model_class.allowed_admin_sort?(@sort)
      raise Pundit::NotAuthorizedError, "Unknown sort param [#{@sort}]."
    end

    policy_scope(model_class).send(@scope).order(@sort).page(@page)
  end
end
