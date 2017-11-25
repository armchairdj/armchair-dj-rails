module ApplicationHelper
  def content_for_unless_empty(key)
    return unless content_for?(key.to_sym)

    yield(key.to_sym)
  end

  def copyright_notice
    start     = "1996"
    now       = Time.now.strftime "%Y"
    daterange = start == now ? start : "#{start}-#{now}"

    "&copy; #{daterange} Brian J. Dillard".html_safe
  end

  def page_title
    raise NoMethodError unless @title

    [@title, "Armchair DJ"].flatten.join(" | ")
  end

  def site_logo
    image_tag("armchair.jpg", class: "chair")
  end

  def site_title
    "Armchair#{content_tag(:span, "DJ")}".html_safe
  end
end
