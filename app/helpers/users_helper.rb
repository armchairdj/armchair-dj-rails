# frozen_string_literal: true

module UsersHelper
  def link_to_user(user, admin: false, **opts)
    return unless admin || user.published?

    text = user.username
    url  = admin ? admin_user_path(user) : user_path(user)

    link_to(text, url, **opts)
  end

  def link_to_author_of(obj, **opts)
    return unless link = link_to_user(obj.author, admin: !!opts.delete(:admin), rel: "author")

    content_tag(:address, link, **combine_attrs(opts, class: "author"))
  end
end
