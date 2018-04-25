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

  # GET /<plural_param_key>
  # GET /<plural_param_key>.json
  def index

  end

  # GET /<plural_param_key>/1
  # GET /<plural_param_key>/1.json
  def show

  end
end