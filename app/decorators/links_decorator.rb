# frozen_string_literal: true

class LinksDecorator < CollectionDecorator
  def list(**opts)
    return if object.empty?

    list = object.map { |link| h.content_tag(:li, h.link_to(link.description, link.url)) }

    h.content_tag(:ul, list.join.html_safe, **opts)
  end
end
