class Admin::GenresController < ApplicationController
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

  # GET /admin/genres
  # GET /admin/genres.json
  def index

  end

  # GET /admin/genres/1
  # GET /admin/genres/1.json
  def show

  end

  # GET /admin/genres/new
  def new

  end

  # POST /admin/genres
  # POST /admin/genres.json
  def create
    respond_to do |format|
      if @admin_genre.save
        format.html { redirect_to @admin_genre, success: I18n.t("#{singular_table_name}.success.create") }
        format.json { render :show, status: :created, location: @admin_genre }
      else
        format.html { render :new }
        format.json { render json: @admin_genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/genres/1/edit
  def edit

  end

  # PATCH/PUT /admin/genres/1
  # PATCH/PUT /admin/genres/1.json
  def update
    respond_to do |format|
      if @admin_genre.update(instance_params)
        format.html { redirect_to @admin_genre, success: I18n.t("#{singular_table_name}.success.update") }
        format.json { render :show, status: :ok, location: @admin_genre }
      else
        format.html { render :edit }
        format.json { render json: @admin_genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/genres/1
  # DELETE /admin/genres/1.json
  def destroy
    @admin_genre.destroy

    respond_to do |format|
      format.html { redirect_to admin_genres_url, success: I18n.t("#{singular_table_name}.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize @admin_genres
  end

  def find_collection
    @admin_genres = policy_scope(Admin::Genre)
  end

  def build_new_instance
    @admin_genre = Admin::Genre.new(instance_params)
  end

  def find_instance
    @admin_genre = Admin::Genre.find(params[:id])
  end

  def authorize_instance
    authorize @admin_genre
  end

  def instance_params
    params.fetch(:admin_genre, {})
  end
end
