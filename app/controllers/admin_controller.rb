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
    @scope = (params[:scope] || model_class.default_admin_scope).to_sym
    @page  = params[:page]

    policy_scope(model_class).send(@scope).page(@page)
  end
end
