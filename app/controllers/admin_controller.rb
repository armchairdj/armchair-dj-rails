# frozen_string_literal: true

class AdminController < ApplicationController
  include Paginatable

  before_action :authorize_model, only: [
    :index,
    :new,
    :create
  ]

  before_action :find_collection, only: [
    :index
  ]

  before_action :build_new_instance, only: [
    :new,
    :create
  ]

  before_action :find_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  before_action :authorize_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  before_action :prepare_form, only: [
    :new,
    :edit
  ]

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

  def scoped_instance(id)
    scope = policy_scope(model_class)

    if model_class.respond_to?(:friendly)
      scope.friendly.find(id)
    else
      scope.find(id)
    end
  end

  def allowed_scopes
    base = { "All" => :for_admin }

    return base unless model_class.include? Viewable

    base.merge({
      "Visible" => :viewable,
      "Hidden"  => :unviewable,
    })
  end

  def allowed_sorts(extra = nil)
    default_sort  = "#{model_class.table_name}.updated_at DESC"
    viewable_sort = "#{model_class.table_name}.viewable ASC"
    id_sort       = "#{model_class.table_name}.id ASC"

    base = {
      "Default" => default_sort,
      "ID"      => id_sort
    }

    return base unless model_class.include? Viewable

    base.merge({
      "Viewable" => [viewable_sort, extra].compact.join(", "),
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
    clause = @dir == "DESC" ? reverse_sort(clause) : clause

    Arel.sql(clause)
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
