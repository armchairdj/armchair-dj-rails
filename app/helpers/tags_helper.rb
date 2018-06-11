# frozen_string_literal: true

module TagsHelper
  def link_to_tag(tag, admin: false, full: false, **opts)
    return unless admin || tag.viewable?

    text = full  ? tag.display_name    : tag.name
    url  = admin ? admin_tag_path(tag) : tag_path(tag)

    link_to(text, url, **opts)
  end
end
