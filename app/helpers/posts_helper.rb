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
end
