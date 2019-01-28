# frozen_string_literal: true

module MixtapesHelper
  def decorated_mixtape_type(mixtape)
    [
      semantic_icon("list", title: "mixtape", desc: "mixtape icon"),
      content_tag(:span, mixtape.display_type)
    ].join.html_safe
  end

  def mixtape_title(mixtape, length: nil, full: true)
    smart_truncate(mixtape.playlist.title, length: length)
  end

  def link_to_mixtape(mixtape, admin: false, full_url: false, text: nil, length: nil, **opts)
    return unless url = url_for_mixtape(mixtape, admin: admin, full_url: full_url)

    text ||= mixtape_title(mixtape, length: length)

    link_to(text, url, **opts)
  end

  def url_for_mixtape(mixtape, admin: false, full_url: false, format: nil)
    if admin
      if full_url
        admin_mixtape_url(mixtape, format: format)
      else
        admin_mixtape_path(mixtape, format: format)
      end
    elsif mixtape.published?
      if full_url
        mixtape_url(mixtape.slug, format: format)
      else
        mixtape_path(mixtape.slug, format: format)
      end
    end
  end
end
