# frozen_string_literal: true

module PlaylistsHelper
  def link_to_playlist(playlist, admin: false, **opts)
    return unless admin || playlist.viewable?

    text = playlist.title
    url  = admin ? admin_playlist_path(playlist) : playlist_path(playlist)

    link_to(text, url, **opts)
  end
end
