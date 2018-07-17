# frozen_string_literal: true

class Admin::BaseController < ApplicationController
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

  before_action :prepare_show, only: [
    :show
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

  def prepare_form; end
  def prepare_show; end

  #############################################################################
  # SCOPING AND SORTING.
  #############################################################################

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

    scope = policy_scope(model_class).for_list.send(current_scope_value)

    scope.order(current_sort_value).page(@page)
  end

  def scoped_instance(id)
    policy_scope(model_class).for_show.find(id)
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
    clause = [allowed_sorts[@sort]].flatten.join(", ")

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

  def allowed_scopes
    { "All" => :all }
  end

  def allowed_sorts
    {
      "Default" => default_sort,
      "ID"      => id_sort
    }
  end

  #############################################################################
  # GENERAL SORT CLAUSES (applied to current model).
  #############################################################################

  def alpha_sort
    "#{model_class.table_name}.alpha ASC"
  end

  def default_sort
    "#{model_class.table_name}.updated_at DESC"
  end

  def id_sort
    "#{model_class.table_name}.id ASC"
  end

  def name_sort
    "LOWER(#{model_class.table_name}.name) ASC"
  end

  def title_sort
    "LOWER(#{model_class.table_name}.title) ASC"
  end

  #############################################################################
  # SPECIFIC SORT CLAUSES (for individual models or join models).
  #############################################################################

  def aspect_facet_sort
    Aspect.alpha_order_clause_for(:facet)
  end

  def creator_individual_sort
    "creators.individual ASC"
  end

  def creator_primary_sort
    "creators.primary ASC"
  end

  def post_status_sort
    "posts.status ASC"
  end

  def role_medium_sort
    "LOWER(roles.medium) ASC"
  end

  def user_email_sort
    "LOWER(users.email) ASC"
  end

  def user_role_sort
    "users.role ASC"
  end

  def user_username_sort
    "users.username ASC"
  end

  def work_makers_sort
    "LOWER(works.display_makers) ASC"
  end

  def work_medium_sort
    "LOWER(works.medium) ASC"
  end
end
