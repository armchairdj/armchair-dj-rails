# frozen_string_literal: true

class MixtapeDecorator < PostDecorator
  def title(length: nil)
    h.smart_truncate(object.playlist.title, length: length)
  end

  def link(admin: false, length: nil, **opts)
    return unless admin || object.published?

    text = title(length: length)
    url  = admin ? admin_mixtape_path(object) : mixtape_path(object)

    h.link_to(text, url, **opts)
  end
end
