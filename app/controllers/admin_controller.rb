# frozen_string_literal: true

class AdminController < ApplicationController
  include SeoPaginatable

  after_action :verify_authorized

private

  def determine_layout
    "admin"
  end

  def scoped_and_sorted_collection
    @scope = params[:scope].try(:to_sym) || default_scope
    @sort  = params[:sort]               || default_sort
    @page  = params[:page]

    unless allowed_scope?(@scope)
      raise Pundit::NotAuthorizedError, "Unknown scope param [#{@scope}]."
    end

    unless allowed_sort?(@sort)
      raise Pundit::NotAuthorizedError, "Unknown sort param [#{@sort}]."
    end

    policy_scope(model_class).send(@scope).order(@sort).page(@page)
  end

  def allowed_scopes
    { "All" => :for_admin }
  end

  helper_method :allowed_scopes

  def default_scope
    allowed_scopes.values.first
  end

  helper_method :default_scope

  def allowed_scope?(scope)
    allowed_scopes.values.include? scope
  end

  def allowed_sorts(extra = nil)
    base = { "Default" => "#{controller_name}.updated_at DESC" }

    return base unless model_class.include? Viewable

    base.merge({
      "VPC"  => ["#{controller_name}.viewable_post_count ASC",     extra].compact.join(", "),
      "NVPC" => ["#{controller_name}.non_viewable_post_count ASC", extra].compact.join(", "),
    })
  end

  helper_method :allowed_sorts

  def default_sort
    allowed_sorts.values.first
  end

  helper_method :default_sort

  def allowed_sort?(sort)
    allowed = allowed_sorts.values.map { |s| helpers.base_sort_clause(s) }

    allowed.include? helpers.base_sort_clause(sort)
  end
end
