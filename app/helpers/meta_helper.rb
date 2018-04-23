module MetaHelper
  def head_tags
    [
      csrf_meta_tags,
      content_type_tag,
      description_tag,
      turbolinks_tag,
      viewport_tag,
      apple_icon_tag,
      favicon_tag,
      shortcut_tag,
      rss_tag,
    ].delete_if(&:blank?).join("\n").html_safe
  end

  ###############################################################################
  # META TAGS.
  ###############################################################################

  def meta_tag(name, content = nil, name_key: "name")
    return unless content

    tag(:meta, name_key => name, "content" => content.to_s.gsub('"', '')).html_safe
  end

  def content_type_tag
    meta_tag("Content-Type", "text/html; charset=utf-8", name_key: "http-equiv")
  end

  def description_tag
    meta_tag("description", @meta_description)
  end

  def turbolinks_tag
    meta_tag("turbolinks-cache-control", "no-preview")
  end

  def viewport_tag
    meta_tag("viewport", "width = device-width, initial-scale = 1.0")
  end

  ###############################################################################
  # ICONS & LINKS.
  ###############################################################################

  def apple_icon_tag
    tag(:link, rel: "apple-touch-icon", href: image_url("apple-touch-icon-precomposed.png"))
  end

  def favicon_tag
    tag(:link, rel: "icon", sizes: "192x192", href: "/favicon.ico")
  end

  def rss_tag
    auto_discovery_link_tag(:rss, feed_url(format: :rss))
  end

  def shortcut_tag
    tag(:link, rel: "shortcut icon", type: "image/x-icon", href: "/favicon.ico")
  end
end
