# frozen_string_literal: true

class LinksDecorator < CollectionDecorator
  def list(**opts)
    return if object.empty?

    list = object.map { |link| content_tag(:li, link_to(link.description, link.url)) }

    content_tag(:ul, list.join.html_safe, **opts)
  end
end
