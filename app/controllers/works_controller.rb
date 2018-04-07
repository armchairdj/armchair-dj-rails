class WorksController < ApplicationController
  before_action :authorize_collection, only: [
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

  # GET /works
  # GET /works.json
  def index

  end

  # GET /works/1
  # GET /works/1.json
  def show

  end

  # GET /works/new
  def new

  end

  # POST /works
  # POST /works.json
  def create
    respond_to do |format|
      if @work.save
        format.html { redirect_to @work, notice: I18n.t("#{singular_table_name}.notice.create") }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /works/1/edit
  def edit

  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(instance_params)
        format.html { redirect_to @work, notice: I18n.t("#{singular_table_name}.notice.update") }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    @work.destroy

    respond_to do |format|
      format.html { redirect_to works_url, notice: I18n.t("#{singular_table_name}.notice.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize class_name
  end

  def find_collection
    @works = policy_scope(Work)
  end

  def build_new_instance
    @work = Work.new(instance_params)
  end

  def find_instance
    @work = Work.find(params[:id])
  end

  def authorize_instance
    authorize @work
  end

  def instance_params
    params.fetch(:work, {})
  end
end
