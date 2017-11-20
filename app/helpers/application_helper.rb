module ApplicationHelper
  def content_for_unless_empty(key)
    return unless content_for?(key)

    content_for(key)
  end

  def copyright_notice
    start     = "1996"
    now       = Time.now.strftime "%Y"
    daterange = start == now ? start : "#{start}-#{now}"

    "&copy; #{daterange} Brian J. Dillard".html_safe
  end

  def site_logo
    content_tag(:span, "logo")
  end

  def site_title
    "Armchair #{content_tag(:span, "DJ")}".html_safe
  end
end
