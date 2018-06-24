# frozen_string_literal: true

module TagsHelper
  def link_to_tag(tag, **opts)
    text = tag.name
    url  = admin_tag_path(tag)

    link_to(text, url, **opts)
  end
end
