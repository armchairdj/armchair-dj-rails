# frozen_string_literal: true

module CreatorsHelper
  def link_to_creator(instance, admin: false, **opts)
    return unless admin || instance.viewable?

    text = instance.name
    url  = admin ? admin_creator_path(instance) : creator_permalink_path(slug: instance.slug)

    link_to(text, url, **opts)
  end
end
