module ApplicationHelper
  def content_for_unless_empty(key)
    return unless content_for?(key)

    content_for(key)
  end

  def copyright_notice
    start     = "1996"
    now       = Time.now.strftime "%Y"

    daterange = start
    daterange << "-#{now}" unless start == now

    "&copy; #{daterange} Brian J. Dillard".html_safe
  end
end
