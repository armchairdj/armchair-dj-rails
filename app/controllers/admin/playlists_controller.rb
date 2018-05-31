class Admin::PlaylistsController < AdminController
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

  before_action :authorize_collection, only: [
    :index,
    :new,
    :create
  ]

  before_action :authorize_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  # GET /admin/playlists
  # GET /admin/playlists.json
  def index; end

  # GET /admin/playlists/1
  # GET /admin/playlists/1.json
  def show; end

  # GET /admin/playlists/new
  def new; end

  # POST /admin/playlists
  # POST /admin/playlists.json
  def create
    respond_to do |format|
      if @playlist.save
        format.html { redirect_to admin_playlist_path(@playlist), success: I18n.t("admin.flash.playlists.success.create") }
        format.json { render :show, status: :created, location: admin_playlist_url(@playlist) }
      else
        format.html { render :new }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/playlists/1/edit
  def edit; end

  # PATCH/PUT /admin/playlists/1
  # PATCH/PUT /admin/playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(instance_params)
        format.html { redirect_to admin_playlist_path(@playlist), success: I18n.t("admin.flash.playlists.success.update") }
        format.json { render :show, status: :ok, location: admin_playlist_url(@playlist) }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/playlists/1
  # DELETE /admin/playlists/1.json
  def destroy
    @playlist.destroy

    respond_to do |format|
      format.html { redirect_to admin_playlists_path, success: I18n.t("admin.flash.playlists.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @playlists = scoped_and_sorted_collection
  end

  def build_new_instance
    @playlist = Playlist.new(instance_params)
  end

  def find_instance
    @playlist = scoped_instance(params[:id])
  end

  def authorize_instance
    authorize @playlist
  end

  def instance_params
    params.fetch(:playlist, {}).permit(
      :name,
      :format,
      :allow_multiple
    )
  end

  def allowed_sorts
    title_sort  = "playlists.alpha ASC"
    author_sort = "users.alpha ASC"

    super(title_sort).merge({
      "Title"   => title_sort,
      "Author"  => [author_sort, title_sort].join(", "),
    })
  end
end
