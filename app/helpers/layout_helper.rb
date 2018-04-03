module LayoutHelper
  def page_container_tag
    @page_container || :article
  end

  def page_container_classes
    [
      @page_container_class
    ].flatten.join(" ")
  end

  def wrapper_classes
    [
      "wrapper",
      @crud ? "crud" : "public"
    ].flatten.join(" ")
  end

  def copyright_notice
    start     = "1996"
    now       = Time.now.strftime "%Y"
    daterange = start == now ? start : "#{start}-#{now}"

    "&copy; #{daterange} Brian J. Dillard".html_safe
  end

  def site_logo
    image_tag("armchair.jpg", class: "chair")
  end

  def site_title
    "Armchair#{content_tag(:span, "DJ")}".html_safe
  end

  def page_title
    if @homepage
      return "Armchair DJ: a monologue about music, with occasional mixtapes"
    end

    raise NoMethodError.new("This page needs a title") unless @title

    [@title, "Armchair DJ"].flatten.compact.join(" | ")
  end
end
