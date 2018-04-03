module PostsHelper
  def link_to_post(post, full: false)
    text = if post.work
      full ?  post.work.title_with_creator : post.work.title
    else
      post.title
    end

    link_to text, post
  end

  def post_type(post)
    post.work ? "#{post.work.human_enum_label(:medium).downcase} review" : "standalone"
  end
end
