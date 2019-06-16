# frozen_string_literal: true

module Posts
  class PostsController < ApplicationController
    include Paginatable

    def self.feed_post_count
      100
    end

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
      @posts = policy_scope(Post).for_list.page(1).per(self.class.feed_post_count)

      render layout: false
    end
  end
end
