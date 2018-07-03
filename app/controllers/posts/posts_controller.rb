# frozen_string_literal: true

class Posts::PostsController < ApplicationController
  include Paginatable

  before_action :authorize_model, only: [
    :index
  ]

  before_action :find_collection, only: [
    :index
  ]

  before_action :set_flag, only: [
    :index
  ]

  # GET /
  # GET /.json
  def index; end

  # GET /feed.rss
  def feed
    @posts = policy_scope(Post).page(1).per(100)

    render layout: false
  end

private

  def set_flag
    @homepage = true if request.url == "/"
  end

  def find_collection
    @posts = @collection = policy_scope(Post).page(params[:page])
  end
end
