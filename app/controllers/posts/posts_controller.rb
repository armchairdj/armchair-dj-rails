# frozen_string_literal: true

module Posts
  class PostsController < ApplicationController
    include Paginatable

    before_action :authorize_model

    # GET /
    # GET /.json
    def index
      @posts = policy_scope(Post).for_list.page(params[:page])

      @homepage = true if request.url == "/"

      @section = :all
    end

    # GET /feed.rss
    def feed
      @posts = policy_scope(Post).for_list.page(1).per(100)

      render layout: false
    end
  end
end
