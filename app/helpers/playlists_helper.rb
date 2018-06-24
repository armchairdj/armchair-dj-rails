# frozen_string_literal: true

module PlaylistsHelper
  def link_to_playlist(playlist, **opts)
    text = playlist.title
    url  = admin_playlist_path(playlist)

    link_to(text, url, **opts)
  end
end
