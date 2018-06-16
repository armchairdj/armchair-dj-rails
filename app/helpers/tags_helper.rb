# frozen_string_literal: true

module TagsHelper
  def link_to_tag(tag, admin: false, **opts)
    return unless admin

    text = tag.name
    url  = admin ? admin_tag_path(tag) : tag_path(tag)

    link_to(text, url, **opts)
  end
end
