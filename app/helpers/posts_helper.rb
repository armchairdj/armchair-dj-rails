module PostsHelper
  def link_to_post(post, full: false)
    link_to post_title(post, full: full), post_permalink_path(slug: post.id)
  end

  def post_title(post, full: false)
    if post.work.present?
      full ? post.work.title_with_creator : post.work.title
    else
      post.title
    end
  end

  def post_type(post)
    post.work ? "#{post.work.human_medium.downcase} review" : 'standalone post'
  end
end
