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

  def post_published_date(post)
    return unless post.published?

    time_tag post.published_at, post.published_at.strftime("%m/%d/%Y at %I:%M%p")
  end

  def post_scheduled_date(post)
    return unless post.scheduled?

    time_tag post.publish_on, post.publish_on.strftime("%m/%d/%Y at %I:%M%p")
  end

  def post_title(post, full: true)
    if post.review?
      full ? post.work.full_display_title : post.work.display_title
    else
      post.title
    end
  end

  def post_type(post)
    post.work ? "#{post.work.human_medium} Review" : "Standalone Post"
  end

  def post_type_for_site(post)
    return unless post.work

    post_type(post)
  end

  def post_status_icon(post)
    return post_draft_icon     if post.draft?
    return post_scheduled_icon if post.scheduled?
    return post_published_icon if post.published?
  end

  def post_draft_icon
    svg_icon("open_iconic/lock-locked.svg",
      title: "draft", desc: "draft icon", wrapper_class: "post-draft"
    )
  end

  def post_published_icon
    svg_icon("open_iconic/lock-unlocked.svg",
      title: "published", desc: "published icon", wrapper_class: "post-published"
    )
  end

  def post_scheduled_icon
    svg_icon("open_iconic/clock.svg",
      title: "scheduled to be published", desc: "scheduled icon", wrapper_class: "post-scheduled"
    )
  end
end
