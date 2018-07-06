# frozen_string_literal: true

class TagDecorator < InstanceDecorator
  def link(**opts)
    text = object.name
    url  = admin_tag_path(object)

    link_to(text, url, **opts)
  end
end
