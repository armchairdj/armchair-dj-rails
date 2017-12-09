class ArtistsController < ApplicationController
  before_action :find_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  before_action :create_new_instance, only: [
    :new,
    :create
  ]

  before_action :authorize_instance, only: [
    :index,
    :new,
    :create
  ]

  before_action :authorize_collection, only: [
    :index,
    :new,
    :create
  ]

  # GET /artists
  # GET /artists.json
  def index
    @artists = policy_scope(Artist)
  end

  # GET /artists/1
  # GET /artists/1.json
  def show

  end

  # GET /artists/new
  def new

  end

  # POST /artists
  # POST /artists.json
  def create

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, notice: 'Artist was successfully created.' }
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /artists/1/edit
  def edit

  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    respond_to do |format|
      if @artist.update(instance_params)
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private

  def find_instance
    @artist = Album.find(params[:id])
  end

  def create_new_instance
    @artist = Artist.new(instance_params)
  end

  def authorize_instance
    authorize @artist
  end

  def authorize_collection
    authorize Artist
  end

  def instance_params
    params.fetch(:artist, {}).permit(:name)
  end
end
