module PostsHelper
  def link_to_post(post, full: false)
    text = if post.work.present?
      full ?  post.work.title_with_creator : post.work.title
    else
      post.title
    end

    link_to text, post_permalink_path(slug: post.id)
  end

  def post_type(post)
    post.work ? "#{post.work.human_enum_value(:medium).downcase} review" : 'standalone post'
  end
end
