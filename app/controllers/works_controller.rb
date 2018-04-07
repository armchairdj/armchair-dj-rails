class WorksController < ApplicationController
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

  # GET /works
  # GET /works.json
  def index

  end

  # GET /works/1
  # GET /works/1.json
  def show

  end

private

  def find_collection
    @works = policy_scope(Work)
  end

  def find_instance
    @work = Work.find(params[:id])
  end

  def authorize_collection
    authorize @works
  end

  def authorize_instance
    authorize @work
  end
end
