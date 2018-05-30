# frozen_string_literal: true

class PublicController < ApplicationController
  include SeoPaginatable

  before_action :find_collection, only: [
    :index
  ]

  before_action :find_instance, only: [
    :show
  ]

  before_action :authorize_collection, only: [
    :index
  ]

  before_action :authorize_instance, only: [
    :show
  ]

  before_action :set_meta_tags, only: [
    :show
  ]

  # GET /<plural_param_key>
  # GET /<plural_param_key>.json
  def index; end

  # GET /<plural_param_key>/1
  # GET /<plural_param_key>/1.json
  def show; end

private

  def set_meta_tags
    @meta_description = @instance.summary
  end

  def authorize_instance
    authorize @instance
  end

  def scoped_collection
    policy_scope(model_class).page(params[:page])
  end

  def scoped_instance_by_slug
    @instance = policy_scope(model_class).find_by!(slug: params[:slug])
  end
end