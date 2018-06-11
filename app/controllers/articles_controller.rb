# frozen_string_literal: true

class ArticlesController < PublicController
  before_action :set_flag, only: [
    :index
  ]

  # GET /feed.rss
  def feed
    @articles = policy_scope(Article).page(1).per(100)

    render layout: false
  end

private

  def set_flag
    @homepage = true if request.url == "/"
  end

  def find_collection
    @articles = scoped_collection
  end

  def find_instance
    @article = scoped_instance
  end
end
