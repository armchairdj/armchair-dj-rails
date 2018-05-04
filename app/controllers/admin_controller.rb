# frozen_string_literal: true

class AdminController < ApplicationController
  include SeoPaginatable

  before_action :is_admin

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

  before_action :authorize_collection, only: [
    :index,
    :new,
    :create
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

  def determine_layout
    "admin"
  end

  def is_admin
    @admin = true
  end

  def prepare_form; end

  def scoped_and_sorted_collection
    @page  = params[:page]
    @scope = (params[:scope] || model_class.default_admin_scope).to_sym

    raise Pundit::NotAuthorizedError unless model_class.admin_scopes.values.include? @scope

    policy_scope(model_class).send(@scope).order(created_at: :desc).page(@page)
  end
end
