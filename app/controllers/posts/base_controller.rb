# frozen_string_literal: true

class Posts::BaseController < ApplicationController
  include Paginatable

  before_action :authorize_model, only: [
    :index
  ]

  before_action :find_collection, only: [
    :index
  ]

  before_action :find_instance, only: [
    :show
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

  # GET /<plural_param_key>/friendly_id
  # GET /<plural_param_key>/friendly_id.json
  def show; end

private

  def find_collection
    @collection = policy_scope(model_class).for_list.page(params[:page])

    instance_variable_set(:"@#{controller_name}", @collection)
  end

  def find_instance
    @instance = policy_scope(model_class).for_show.find_by(slug: params[:slug])

    instance_variable_set(:"@#{controller_name.singularize}", @instance)
  end

  def authorize_instance
    authorize @instance
  end

  def set_meta_tags
    @meta_description = @instance.summary
  end
end
