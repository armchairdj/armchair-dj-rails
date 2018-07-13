# frozen_string_literal: true

module MixtapesHelper
  def mixtape_title(mixtape, length: nil)
    smart_truncate(mixtape.playlist.title, length: length)
  end

  def link_to_mixtape(mixtape, admin: false, length: nil, **opts)
    return unless admin || mixtape.published?

    text = mixtape_title(mixtape, length: length)
    url  = admin ? admin_mixtape_path(mixtape) : mixtape_path(mixtape.slug)

    link_to(text, url, **opts)
  end
end
