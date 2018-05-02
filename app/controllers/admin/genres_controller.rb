class Admin::GenresController < AdminController
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
      if @genre.save
        format.html { redirect_to @genre, success: I18n.t("#{singular_table_name}.success.create") }
        format.json { render :show, status: :created, location: @genre }
      else
        format.html { render :new }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
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
      if @genre.update(instance_params)
        format.html { redirect_to @genre, success: I18n.t("#{singular_table_name}.success.update") }
        format.json { render :show, status: :ok, location: @genre }
      else
        format.html { render :edit }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/genres/1
  # DELETE /admin/genres/1.json
  def destroy
    @genre.destroy

    respond_to do |format|
      format.html { redirect_to genres_url, success: I18n.t("#{singular_table_name}.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @genres = scoped_and_sorted_collection.order(created_at: :desc)
  end

  def build_new_instance
    @genre = Genre.new(instance_params)
  end

  def find_instance
    @genre = Genre.find(params[:id])
  end

  def authorize_instance
    authorize @genre
  end

  def instance_params
    params.fetch(:genre, {})
  end
end
