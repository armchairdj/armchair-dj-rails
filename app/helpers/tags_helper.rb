# frozen_string_literal: true

module TagsHelper
  def link_to_tag(tag, **opts)
    text = tag.name
    url  = admin_tag_path(tag)

    link_to(text, url, **opts)
  end

  def tag_list(tags, admin: false, **opts)
    return if tags.empty?

    list = tags.map do |tag|
      content_tag(:li, admin ? link_to_tag(tag) : tag.name)
    end

    content_tag(:ul, list.join.html_safe, **opts)
  end
end
