class CreatorsController < ApplicationController
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

  # GET /creators
  # GET /creators.json
  def index

  end

  # GET /creators/1
  # GET /creators/1.json
  def show

  end

private

  def find_collection
    @creators = policy_scope(Creator)
  end

  def find_instance
    @creator = Creator.find(params[:id])
  end

  def authorize_collection
    authorize @creators
  end

  def authorize_instance
    authorize @creator
  end
end
