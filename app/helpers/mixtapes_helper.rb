# frozen_string_literal: true

module MixtapesHelper
  def decorated_mixtape_type(mixtape)
    [
      semantic_icon("list", title: "mixtape", desc: "mixtape icon"),
      content_tag(:span, mixtape.display_type)
    ].join.html_safe
  end

  def mixtape_title(mixtape, length: nil, full: false)
    return mixtape.playlist.title if full

    smart_truncate(mixtape.playlist.title, length: length)
  end

  def link_to_mixtape(mixtape, admin: false, full_url: false, text: nil, length: nil, **opts)
    return unless (url = uri_for_mixtape(mixtape, admin: admin, full_url: full_url))

    text ||= mixtape_title(mixtape, length: length)

    link_to(text, url, **opts)
  end

  def uri_for_mixtape(mixtape, admin: false, **opts)
    if admin
      uri_for_admin_mixtape(mixtape, **opts)
    elsif mixtape.published?
      uri_for_public_mixtape(mixtape, **opts)
    end
  end

  def uri_for_admin_mixtape(mixtape, full_url: false, format: nil)
    return admin_mixtape_url(mixtape, format: format) if full_url

    admin_mixtape_path(mixtape, format: format)
  end

  def uri_for_public_mixtape(mixtape, full_url: false, format: nil)
    return mixtape_url(mixtape.slug, format: format) if full_url

    mixtape_path(mixtape.slug, format: format)
  end
end
