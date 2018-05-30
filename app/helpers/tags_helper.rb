# frozen_string_literal: true

module TagsHelper
  def link_to_tag(instance, admin: false, full: false, **opts)
    return unless admin || instance.viewable?

    text = full  ? instance.display_name    : instance.name
    url  = admin ? admin_tag_path(instance) : tag_permalink_path(slug: instance.slug)

    link_to(text, url, **opts)
  end
end
