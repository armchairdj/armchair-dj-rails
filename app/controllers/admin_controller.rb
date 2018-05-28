# frozen_string_literal: true

class AdminController < ApplicationController
  include SeoPaginatable

  after_action :verify_authorized

private

  def policy_scope(scope)
    super([:admin, scope])
  end

  def authorize(record, query = nil)
    super([:admin, record], query)
  end

  def determine_layout
    "admin"
  end

  def scoped_and_sorted_collection
    @scope = params[:scope] || allowed_scopes.keys.first
    @sort  = params[:sort ] || allowed_sorts.keys.first
    @dir   = params[:dir  ] || "ASC"
    @page  = params[:page ]

    unless allowed_scopes.keys.include?(@scope)
      raise Pundit::NotAuthorizedError, "Unknown scope param [#{@scope}]."
    end

    unless allowed_sorts.keys.include?(@sort)
      raise Pundit::NotAuthorizedError, "Unknown sort param [#{@sort}]."
    end

    @scopes = scopes_for_view(@scope)
    @sorts  = sorts_for_view(@scope, @sort, @dir)

    policy_scope(model_class).send(current_scope_value).order(current_sort_value).page(@page)
  end

  def allowed_scopes
    base = { "All" => :for_admin }

    return base unless model_class.include? Viewable

    base.merge({
      "Visible" => :viewable,
      "Hidden"  => :non_viewable,
    })
  end

  def allowed_sorts(extra = nil)
    default_sort = "#{controller_name}.updated_at DESC"
    vpc_sort     = "#{controller_name}.viewable_post_count ASC"
    nvpc_sort    = "#{controller_name}.non_viewable_post_count ASC"

    base = { "Default" => default_sort }

    return base unless model_class.include? Viewable

    base.merge({
      "VPC"  => [vpc_sort,  extra].compact.join(", "),
      "NVPC" => [nvpc_sort, extra].compact.join(", "),
    })
  end

  def scopes_for_view(scope)
    allowed_scopes.keys.each.inject({}) do |memo, (key)|
      memo[key] = {
        :active? => key == scope,
        :url     => polymorphic_path([:admin, model_class], scope: key)
      }
      memo
    end
  end

  def sorts_for_view(scope, sort, dir)
    allowed_sorts.keys.each.inject({}) do |memo, (key)|
      active    = key == sort
      link_dir  = active && dir == "ASC" ? "DESC" : "ASC"
      memo[key] = {
        :active? => active,
        :desc?   => dir == "DESC",
        :url     => polymorphic_path([:admin, model_class], scope: scope, sort: key, dir: link_dir)
      }
      memo
    end
  end

  def current_scope_value
    allowed_scopes[@scope]
  end

  def current_sort_value
    clause = allowed_sorts[@sort]

    @dir == "DESC" ? reverse_sort(clause) : clause
  end

  def reverse_sort(clause)
    parts = clause.split(/, ?/)

    if parts[0].match(/DESC/)
      parts[0] = parts[0].gsub("DESC", "ASC")
    elsif parts[0].match(/ASC/)
      parts[0] = parts[0].gsub("ASC", "DESC")
    else
      parts[0] = "#{parts[0]} DESC"
    end

    parts.join(", ")
  end
end
