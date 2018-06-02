# frozen_string_literal: true

module PlaylistsHelper
  def link_to_playlist(instance, admin: false, **opts)
    return unless admin || instance.viewable?

    text = instance.title
    url  = admin ? admin_playlist_path(instance) : playlist_permalink_path(slug: instance.slug)

    link_to(text, url, **opts)
  end
end
