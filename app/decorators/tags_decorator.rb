# frozen_string_literal: true

class TagsDecorator < CollectionDecorator
  def list(admin: false, **opts)
    return if object.empty?

    list = object.map do |tag|
      content_tag(:li, admin ? tag.decorate.link : tag.name)
    end

    content_tag(:ul, list.join.html_safe, **opts)
  end
end
