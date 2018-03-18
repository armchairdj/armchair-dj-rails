require 'ffaker'

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

  def lorem_html_paragraphs(num = 2)
    FFaker::Lorem.paragraphs(num).map { |p| content_tag(:p, p) }.join.html_safe
  end

  def non_semantic_svg_image(image_path, label = nil, desc = nil)
    opts = {
      nocomment: true,
      aria:      false,
      class:     "scalable-image"
    }

    if label.present && desc.present?
      opts = opts.merge({
        aria:  true,
        title: label,
        desc:  desc,
      })
    end

    inline_svg(image_path, opts)
  end

  def page_title
    if @homepage
      return "Armchair DJ: a monologue about music, with occasional mixtapes"
    end

    raise NoMethodError.new("This page needs a title") unless @title

    [@title, "Armchair DJ"].flatten.compact.join(" | ")
  end

  def semantic_svg_image(image_path, label, desc)
    non_semantic_svg_image(image_path, label, desc)
  end

  def site_logo
    image_tag("armchair.jpg", class: "chair")
  end

  def site_title
    "Armchair#{content_tag(:span, "DJ")}".html_safe
  end
end
