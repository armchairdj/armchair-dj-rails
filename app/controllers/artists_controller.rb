class ArtistsController < ApplicationController
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

  # GET /artists
  # GET /artists.json
  def index

  end

  # GET /artists/1
  # GET /artists/1.json
  def show

  end

private

  def find_collection
    @artists = policy_scope(Artist)
  end

  def find_instance
    @artist = Artist.find(params[:id])
  end

  def authorize_collection
    authorize Artist
  end

  def authorize_instance
    authorize @artist
  end
end
