class PostsController < ApplicationController
  include SeoPaginatable

  before_action :find_collection, only: [
    :index
  ]

  before_action :find_instance, only: [
    :show
  ]

  before_action :authorize_collection, only: [
    :index
  ]

  before_action :authorize_instance, only: [
    :show
  ]

  # GET /
  # GET /.json
  def index
    @homepage = true if request.url == "/"
  end

  # GET /posts/slug
  # GET /posts/slug.json
  def show

  end

private

  def find_collection
    @posts = policy_scope(Post).page(params[:page])
  end

  def find_instance
    @post = Post.find(params[:slug])
  end

  def authorize_collection
    authorize @posts
  end

  def authorize_instance
    authorize @post
  end
end
