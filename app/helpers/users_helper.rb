# frozen_string_literal: true

module UsersHelper
  def link_to_user(instance, admin: false, **opts)
    return unless admin || instance.viewable?

    text = instance.username
    url  = admin ? admin_user_path(instance) : user_profile_path(username: instance.username)

    link_to(text, url, **opts)
  end
end
