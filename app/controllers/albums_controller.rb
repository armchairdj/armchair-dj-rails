class AlbumsController < ApplicationController
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

  before_action :prepare_contributions, only: [
    :new,
    :edit
  ]

  # GET /albums
  # GET /albums.json
  def index

  end

  # GET /albums/1
  # GET /albums/1.json
  def show

  end

  # GET /albums/new
  def new

  end

  # POST /albums
  # POST /albums.json
  def create
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: I18n.t("album.notice.create") }
        format.json { render :show, status: :created, location: @album }
      else
        prepare_contributions

        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /albums/1/edit
  def edit

  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(instance_params)
        format.html { redirect_to @album, notice: I18n.t("album.notice.update") }
        format.json { render :show, status: :ok, location: @album }
      else
        prepare_contributions

        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url, notice: I18n.t("album.notice.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize Album
  end

  def find_collection
    @albums = policy_scope(Album)
  end

  def build_new_instance
    @album = Album.new(instance_params)
  end

  def find_instance
    @album = Album.find(params[:id])
  end

  def authorize_instance
    authorize @album
  end

  def instance_params
    params.fetch(:album, {}).permit(
      :title,
      :album_contributions_attributes => [
        :id,
        :album_id,
        :artist_id,
        :role,
        :_destroy
      ]
    )
  end

  def prepare_contributions
    count_needed = Album.max_contributions - @album.album_contributions.length

    count_needed.times { @album.album_contributions.build }

    @artists_for_select = Artist.all.alphabetical
    @roles_for_select   = AlbumContribution.human_enum_collection(:role)
  end
end
