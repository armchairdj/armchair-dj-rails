# frozen_string_literal: true

class TagsDecorator < CollectionDecorator
  def list(admin: false, **opts)
    return if object.empty?

    list = object.map do |tag|
      h.content_tag(:li, admin ? TagDecorator.new(tag).link : tag.name)
    end

    h.content_tag(:ul, list.join.html_safe, **opts)
  end
end
