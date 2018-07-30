# frozen_string_literal: true

class Admin::Posts::MixtapesController < Admin::Posts::BaseController

private

  def keys_for_create
    [:playlist_id]
  end

  def prepare_form
    super

    @playlists = Playlist.alpha
  end
end
