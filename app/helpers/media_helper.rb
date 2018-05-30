# frozen_string_literal: true

module MediaHelper
  def link_to_medium(instance, admin: false, **opts)
    return unless admin || instance.viewable?

    text = instance.name
    url  = admin ? admin_medium_path(instance) : medium_permalink_path(slug: instance.slug)

    link_to(text, url, **opts)
  end
end
