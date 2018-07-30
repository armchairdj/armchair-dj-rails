# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  include Paginatable

  before_action :authorize_model, only: [
    :index,
    :new,
    :create
  ]

  before_action :build_collection, only: [
    :index
  ]

  before_action :resolve_collection, only: [
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

  # GET /{collection}
  # GET /{collection}.json
  def index; end

  # GET /{collection}/1
  # GET /{collection}/1.json
  def show; end

  # GET /{collection}/new
  def new; end

  # GET /{collection}/1/edit
  def edit; end

private

  def build_collection
    @collection = Ginsu::Collection.new(
      policy_scope(@model_class).for_list,
      scope:  params[:scope],
      sort:   params[:sort ],
      dir:    params[:dir  ],
      page:   params[:page ]
    )
  end

  def resolve_collection
    instance_variable_set(:"@#{controller_name}", @collection.resolve)
  end

  def find_instance
    @instance = scoped_instance

    instance_variable_set(:"@#{controller_name.singularize}", @instance)
  end

  def build_new_instance
    @instance = @model_class.new

    instance_variable_set(:"@#{controller_name.singularize}", @instance)
  end

  def authorize_instance
    authorize @instance
  end

  def policy_scope(scope)
    super([:admin, scope])
  end

  def scoped_instance
    policy_scope(@model_class).for_show.find(params[:id])
  end

  def authorize(record, query = nil)
    super([:admin, record], query)
  end

  def determine_layout
    "admin"
  end

  def prepare_form; end
  def prepare_show; end

  def collection_path
    polymorphic_path([:admin, @model_class])
  end

  def edit_path
    edit_polymorphic_path([:admin, @instance])
  end

  def show_path
    polymorphic_path([:admin, @instance])
  end
end
