# frozen_string_literal: true

module UsersHelper
  def link_to_user(user, admin: false, **opts)
    return unless admin || user.published?

    text = user.username
    url  = admin ? admin_user_path(user.to_param) : user_path(user)

    link_to(text, url, **opts)
  end
end
