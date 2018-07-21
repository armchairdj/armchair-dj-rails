# frozen_string_literal: true

class Posts::PostsController < ApplicationController
  include Paginatable

  before_action :authorize_model

  # GET /
  # GET /.json
  def index
    @posts = @collection = policy_scope(Post).for_list.page(params[:page])

    @homepage = true if request.url == "/"
  end

  # GET /feed.rss
  def feed
    @posts = policy_scope(Post).for_list.page(1).per(100)

    render layout: false
  end
end
