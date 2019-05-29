# frozen_string_literal: true

module UsersHelper
  def link_to_author_of(obj, admin: false, **opts)
    return unless (link = link_to_user(obj.author, admin: admin, rel: "author"))

    content_tag(:address, link, **combine_attrs(opts, class: "author"))
  end

  def link_to_user(user, admin: false, full_url: false, text: nil, **opts)
    return unless (url = url_for_user(user, admin: admin, full_url: full_url))

    text ||= user.username

    link_to(text, url, **opts)
  end

  def url_for_user(user, admin: false, full_url: false, format: nil)
    return unless admin || user.published?

    url_opts = admin ? [:admin, user] : user

    if full_url
      polymorphic_url(url_opts, format: format)
    else
      polymorphic_path(url_opts, format: format)
    end
  end
end
