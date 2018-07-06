# frozen_string_literal: true

class UserDecorator < InstanceDecorator
  def link(admin: false, **opts)
    return unless admin || object.published?

    route_helpers = Rails.application.routes.url_helpers

    text = object.username
    url  = admin ? route_helpers.admin_user_path(object) : route_helpers.user_path(object)

    h.link_to(text, url, **opts)
  end
end
