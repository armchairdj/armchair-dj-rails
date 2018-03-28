class SongsController < ApplicationController
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

  # GET /songs
  # GET /songs.json
  def index

  end

  # GET /songs/1
  # GET /songs/1.json
  def show

  end

  # GET /songs/new
  def new

  end

  # POST /songs
  # POST /songs.json
  def create
    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: I18n.t("song.notice.create") }
        format.json { render :show, status: :created, location: @song }
      else
        prepare_contributions

        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /songs/1/edit
  def edit

  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(instance_params)
        format.html { redirect_to @song, notice: I18n.t("song.notice.update") }
        format.json { render :show, status: :ok, location: @song }
      else
        prepare_contributions

        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url, notice: I18n.t("song.notice.destroy") }
      format.json { head :no_content }
    end
  end

private

  def authorize_collection
    authorize Song
  end

  def find_collection
    @songs = policy_scope(Song)
  end

  def build_new_instance
    @song = Song.new(instance_params)
  end

  def find_instance
    @song = Song.find(params[:id])
  end

  def authorize_instance
    authorize @song
  end

  def instance_params
    params.fetch(:song, {}).permit(
      :title,
      :song_contributions_attributes => [
        :id,
        :_destroy,
        :song_id,
        :artist_id,
        :role
      ]
    )
  end

  def prepare_contributions
    count_needed = Song.max_contributions - @song.song_contributions.length

    count_needed.times { @song.song_contributions.build }

    @artists_for_select = Artist.all.alphabetical
    @roles_for_select   = SongContribution.human_enum_collection(:role)
  end
end
