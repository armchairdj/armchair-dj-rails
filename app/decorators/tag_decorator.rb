# frozen_string_literal: true

class TagDecorator < InstanceDecorator
  def link(**opts)
    text = object.name
    url  = h.admin_tag_path(object)

    h.link_to(text, url, **opts)
  end
end
