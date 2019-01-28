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

  def semantic_icon(icon, title:, desc:, **opts)
    image_path = "open_iconic/#{icon}.svg"

    semantic_svg_image(image_path, title: title, desc: desc, **opts)
  end

  def wrapped_icon(icon, tag: :span, wrapper_class: nil, **opts)
    wrapper_class = combine_classes("svg-icon", wrapper_class)
    svg           = semantic_icon(icon, opts)

    content_tag(tag, svg, class: wrapper_class)
  end
end
