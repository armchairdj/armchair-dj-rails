class SongsController < ApplicationController
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

  # GET /songs
  # GET /songs.json
  def index

  end

  # GET /songs/1
  # GET /songs/1.json
  def show

  end

private

  def find_collection
    @songs = policy_scope(Song)
  end

  def find_instance
    @song = Song.find(params[:id])
  end

  def authorize_collection
    authorize Song
  end

  def authorize_instance
    authorize @song
  end
end
