class PostsController < ApplicationController
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

  # GET /posts
  # GET /posts.json
  def index
    if params[:page].blank? || params[:page] == "1"
      return redirect_to root_path unless request.url == root_url
    end

    @homepage = true if request.url == "/"
  end

  # GET /posts/1
  # GET /posts/1.json
  def show

  end

private

  def find_collection
    @posts = policy_scope(Post).page(params[:page])
  end

  def find_instance
    @post = Post.find(params[:id])
  end

  def authorize_collection
    authorize @posts
  end

  def authorize_instance
    authorize @post
  end
end
