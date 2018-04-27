# frozen_string_literal: true

module SvgHelper
  def non_semantic_svg_image(image_path, title: nil, desc: nil, **opts)
    attrs = combine_attrs({
      nocomment: true,
      aria:      false,
      class:     ["scalable-image"]
    }, opts)

    unless title.nil? || desc.nil?
      attrs = attrs.merge({
        aria:  true,
        title: title,
        desc:  desc,
      })
    end

    inline_svg(image_path, attrs)
  end

  def semantic_svg_image(image_path, title:, desc:, **opts)
    non_semantic_svg_image(image_path, title: title, desc: desc, **opts)
  end

  def svg_icon(image_path, **opts)
    wrapper_class = combine_classes("svg-icon", opts.delete(:wrapper_class))

    content_tag(:span, semantic_svg_image(image_path, opts), class: wrapper_class)
  end

  def svg_abbreviation(image_path, title: title, **opts)
    wrapper_class = combine_classes("svg-icon", opts.delete(:wrapper_class))
    svg           = non_semantic_svg_image(image_path, opts)

    content_tag(:abbr, svg, title: title, class: wrapper_class)
  end
end
