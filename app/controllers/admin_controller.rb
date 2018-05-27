# frozen_string_literal: true

class AdminController < ApplicationController
  include SeoPaginatable

  after_action :verify_authorized

private

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

    @scopes = scopes_for_view
    @sorts  = sorts_for_view

    policy_scope(model_class).send(current_scope_value).order(current_sort_value).page(@page)
  end

  def allowed_scopes
    { "All" => :for_admin }
  end

  def allowed_sorts(extra = nil)
    base = { "Default" => "#{controller_name}.updated_at DESC" }

    return base unless model_class.include? Viewable

    base.merge({
      "VPC"  => ["#{controller_name}.viewable_post_count ASC",     extra].compact.join(", "),
      "NVPC" => ["#{controller_name}.non_viewable_post_count ASC", extra].compact.join(", "),
    })
  end

  def scopes_for_view
    allowed_scopes.keys.each.inject({}) do |memo, (key)|
      memo[key] = {
        :active? => key == @scope,
        :url     => polymorphic_path([:admin, model_class], scope: key)
      }
      memo
    end
  end

  def sorts_for_view
    allowed_sorts.keys.each.inject({}) do |memo, (key)|
      active    = key == @sort
      dir       = active ? reverse_dir(@dir) : "ASC"
      memo[key] = {
        :active? => active,
        :desc?   => dir == "DESC",
        :url     => polymorphic_path([:admin, model_class], scope: @scope, sort: key, dir: dir)
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

  def reverse_dir(dir)
    dir == "ASC" ? "DESC" : "ASC"
  end
end
