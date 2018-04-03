class CreatorsController < ApplicationController
  prepend_before_action :is_crud

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

  # GET /creators
  # GET /creators.json
  def index

  end

  # GET /creators/1
  # GET /creators/1.json
  def show

  end

  # GET /creators/new
  def new

  end

  # POST /creators
  # POST /creators.json
  def create
    respond_to do |format|
      if @creator.save
        format.html { redirect_to creators_path, notice: I18n.t("creator.notice.create") }
        format.json { render :show, status: :created, location: @creator }
      else
        format.html { render :new }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /creators/1/edit
  def edit

  end

  # PATCH/PUT /creators/1
  # PATCH/PUT /creators/1.json
  def update
    respond_to do |format|
      if @creator.update(instance_params)
        format.html { redirect_to creators_path, notice: I18n.t("creator.notice.update") }
        format.json { render :show, status: :ok, location: @creator }
      else
        format.html { render :edit }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /creators/1
  # DELETE /creators/1.json
  def destroy
    @creator.destroy

    respond_to do |format|
      format.html { redirect_to creators_path, notice: I18n.t("creator.notice.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize Creator
  end

  def find_collection
    @creators = policy_scope(Creator).page(params[:page])
  end

  def build_new_instance
    @creator = Creator.new(instance_params)
  end

  def find_instance
    @creator = Creator.find(params[:id])
  end

  def authorize_instance
    authorize @creator
  end

  def instance_params
    params.fetch(:creator, {}).permit(:name)
  end
end
