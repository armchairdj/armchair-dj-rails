module SvgHelper
  def non_semantic_svg_image(image_path, title: nil, desc: nil)
    opts = {
      nocomment: true,
      aria:      false,
      class:     "scalable-image"
    }

    unless title.nil? || desc.nil?
      opts = opts.merge({
        aria:  true,
        title: title,
        desc:  desc,
      })
    end

    inline_svg(image_path, opts)
  end

  def semantic_svg_image(image_path, title:, desc:)
    non_semantic_svg_image(image_path, title: title, desc: desc)
  end
end
