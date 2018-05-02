class Admin::MediaController < ApplicationController
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

  # GET /admin/media
  # GET /admin/media.json
  def index

  end

  # GET /admin/media/1
  # GET /admin/media/1.json
  def show

  end

  # GET /admin/media/new
  def new

  end

  # POST /admin/media
  # POST /admin/media.json
  def create
    respond_to do |format|
      if @admin_medium.save
        format.html { redirect_to @admin_medium, success: I18n.t("#{singular_table_name}.success.create") }
        format.json { render :show, status: :created, location: @admin_medium }
      else
        format.html { render :new }
        format.json { render json: @admin_medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/media/1/edit
  def edit

  end

  # PATCH/PUT /admin/media/1
  # PATCH/PUT /admin/media/1.json
  def update
    respond_to do |format|
      if @admin_medium.update(instance_params)
        format.html { redirect_to @admin_medium, success: I18n.t("#{singular_table_name}.success.update") }
        format.json { render :show, status: :ok, location: @admin_medium }
      else
        format.html { render :edit }
        format.json { render json: @admin_medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/media/1
  # DELETE /admin/media/1.json
  def destroy
    @admin_medium.destroy

    respond_to do |format|
      format.html { redirect_to admin_media_url, success: I18n.t("#{singular_table_name}.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize @admin_media
  end

  def find_collection
    @admin_media = policy_scope(Admin::Medium)
  end

  def build_new_instance
    @admin_medium = Admin::Medium.new(instance_params)
  end

  def find_instance
    @admin_medium = Admin::Medium.find(params[:id])
  end

  def authorize_instance
    authorize @admin_medium
  end

  def instance_params
    params.fetch(:admin_medium, {})
  end
end
