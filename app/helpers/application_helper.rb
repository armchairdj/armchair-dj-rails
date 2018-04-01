require 'ffaker'

module ApplicationHelper
  def create_link(model)
    svg = semantic_svg_image("open_iconic/plus.svg", "plus sign", "addition icon")

    link_to svg, new_polymorphic_path(model),
      title: "edit #{model.model_name.singular}",
      class: "crud create"
  end

  def edit_link(instance)
    svg = semantic_svg_image("open_iconic/pencil.svg", "pencil", "pencil icon")

    link_to svg, edit_polymorphic_path(instance),
      title: "edit #{instance.model_name.singular}",
      class: "crud edit"
  end

  def destroy_link(instance)
    svg = semantic_svg_image("open_iconic/x.svg", "x", "delete icon")

    link_to svg, polymorphic_path(instance),
      method: :delete, "data-confirm": "Are you sure?",
      title: "destroy #{instance.model_name.singular}",
      class: "crud destroy"
  end

  def post_type(post)
    post.work ? "#{post.work.human_enum_label(:medium).downcase} review" : "standalone"
  end

  def content_for_unless_empty(key)
    return unless content_for?(key.to_sym)

    content_for(key.to_sym)
  end

  def copyright_notice
    start     = "1996"
    now       = Time.now.strftime "%Y"
    daterange = start == now ? start : "#{start}-#{now}"

    "&copy; #{daterange} Brian J. Dillard".html_safe
  end

  def links_to_creators_for_work(work)
    work.creators.map { |a| link_to(a.name, a) }.join(" & ").html_safe
  end

  def link_to_post(post, full: false)
    text = if post.work
      full ?  post.work.title_with_creator : post.work.title
    else
      post.title
    end

    link_to text, post
  end

  def link_to_work(work)
    link_to(work.title, work)
  end

  def lorem_html_paragraphs(num = 2)
    FFaker::Lorem.paragraphs(num).map { |p| content_tag(:p, p) }.join.html_safe
  end

  def non_semantic_svg_image(image_path, title = nil, desc = nil)
    opts = {
      nocomment: true,
      aria:      false,
      class:     "scalable-image"
    }

    if title.present? && desc.present?
      opts = opts.merge({
        aria:  true,
        title: title,
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

  def required_indicator
    I18n.t("simple_form.required.html").html_safe
  end

  def semantic_svg_image(image_path, title, desc)
    non_semantic_svg_image(image_path, title, desc)
  end

  def site_logo
    image_tag("armchair.jpg", class: "chair")
  end

  def site_title
    "Armchair#{content_tag(:span, "DJ")}".html_safe
  end
end
