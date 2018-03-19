class AlbumsController < ApplicationController
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

  # GET /albums
  # GET /albums.json
  def index

  end

  # GET /albums/1
  # GET /albums/1.json
  def show

  end

private

  def find_collection
    @albums = policy_scope(Album)
  end

  def find_instance
    @album = Album.find(params[:id])
  end

  def authorize_collection
    authorize Album
  end

  def authorize_instance
    authorize @album
  end
end
