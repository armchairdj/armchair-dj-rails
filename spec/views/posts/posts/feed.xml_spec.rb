# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/posts/feed.rss.builder" do
  before(:each) do
    create(:complete_article, :published)
    create(:complete_review,  :published)
    create(:complete_mixtape, :published)

    @posts = assign(:posts, Post.for_public.page(1))
  end

  it "renders a list of posts in xml format" do
    render
  end
end
