# frozen_string_literal: true

class PostsController < PublicController
  before_action :set_flag, only: [
    :index
  ]

  # GET /feed.rss
  def feed
    @posts = policy_scope(Post).page(1).per(100)

    render layout: false
  end

private

  def set_flag
    @homepage = true if request.url == "/"
  end

private

  def find_collection
    @posts = policy_scope(Post).page(params[:page])
  end

  def find_instance
    @post = Post.find_by!(slug: params[:slug])
  end

  def authorize_instance
    authorize @post
  end

  def set_meta_tags
    @meta_description = @post.summary
  end
end
