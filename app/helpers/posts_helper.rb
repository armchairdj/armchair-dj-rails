module PostsHelper
  def formatted_post_body(post)
    return if post.body.blank?

    post.body.strip.split("\n\n").map { |p| content_tag(:p, p.squish) }.join("\n").html_safe
  end

  def link_to_post(post, full: false)
    return unless post.slug

    link_to post_title(post, full: full), post_permalink_path(slug: post.slug)
  end

  def post_title(post, full: false)
    if post.work
      full ? post.work.title_with_creator : post.work.title
    else
      post.title
    end
  end

  def post_type(post)
    post.work ? "#{post.work.human_medium.downcase} review" : "standalone post"
  end
end
