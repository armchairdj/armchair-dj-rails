# frozen_string_literal: true

module AspectsHelper
  def link_to_aspect(aspect, **opts)
    text = aspect.name
    url  = admin_aspect_path(aspect)

    link_to(text, url, **opts)
  end
end
