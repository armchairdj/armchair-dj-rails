module PostsHelper
  def formatted_post_body(post)
    return if post.body.blank?

    post.body.strip.split("\n\n").map { |p| content_tag(:p, p.squish) }.join("\n").html_safe
  end

  def link_to_post(post, full: true, admin: false)
    return unless post.slug.present? || admin

    text        = post_title(post, full: full)
    url_options = admin ? admin_post_path(post) : post_permalink_path(slug: post.slug)

    link_to(text, url_options)
  end

  def post_title(post, full: true)
    if post.work
      full ? post.work.title_with_creator : post.work.title
    else
      post.title
    end
  end

  def post_type(post)
    post.work ? "#{post.work.human_medium} Review" : "Standalone Post"
  end

  def post_status_icon(post)
    return post_draft_icon     if post.draft?
    return post_scheduled_icon if post.scheduled?
    return post_live_icon      if post.live?
  end

  def post_draft_icon
    svg_icon("open_iconic/lock-locked.svg",
      title: "draft", desc: "draft icon", wrapper_class: "post-draft"
    )
  end

  def post_live_icon
    svg_icon("open_iconic/lock-unlocked.svg",
      title: "published", desc: "published icon", wrapper_class: "post-live"
    )
  end

  def post_scheduled_icon
    svg_icon("open_iconic/clock.svg",
      title: "scheduled to be published", desc: "scheduled icon", wrapper_class: "post-scheduled"
    )
  end
end
