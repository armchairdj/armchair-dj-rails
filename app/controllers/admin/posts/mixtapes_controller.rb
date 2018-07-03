# frozen_string_literal: true

class Admin::Posts::MixtapesController < Admin::Posts::BaseController

private

  def permitted_keys
    super.unshift(:playlist_id)
  end

  def prepare_form
    super

    @playlists = Playlist.for_admin.alpha
  end
end
