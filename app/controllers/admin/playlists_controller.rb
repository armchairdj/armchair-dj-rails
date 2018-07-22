class Admin::PlaylistsController < Admin::BaseController
  before_action :require_ajax, only: :reorder_playlistings

  # POST /admin/playlists
  # POST /admin/playlists.json
  def create
    @playlist.attributes = instance_params

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to show_path, success: I18n.t("admin.flash.playlists.success.create") }
        format.json { render :show, status: :created, location: admin_playlist_url(@playlist) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/playlists/1
  # PATCH/PUT /admin/playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(instance_params)
        format.html { redirect_to show_path, success: I18n.t("admin.flash.playlists.success.update") }
        format.json { render :show, status: :ok, location: admin_playlist_url(@playlist) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/playlists/1
  # DELETE /admin/playlists/1.json
  def destroy
    @playlist.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: I18n.t("admin.flash.playlists.success.destroy") }
      format.json { head :no_content }
    end
  end

  # POST /admin/playlists/1/reorder_playlistings
  def reorder_playlistings
    find_instance
    authorize @playlist, :update?

    Playlisting.reorder_for!(@playlist, params[:playlisting_ids])

    render json: {}, status: :ok
  end

private

  def instance_params
    fetched = params.fetch(:playlist, {}).permit(
      :name,
      :title,
      :author_id,
      playlistings_attributes: [
        :id,
        :_destroy,
        :playlist_id,
        :work_id
      ]
    )

    fetched.merge(author: current_user)
  end

  def prepare_form
    @playlist.prepare_playlistings

    @works = Work.grouped_by_medium
  end

  def allowed_sorts
    {
      "Title"   => alpha_sort,
      "Author"  => [user_username_sort, alpha_sort],
    }
  end
end
