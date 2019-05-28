# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/articles/index" do
  before do
    create_list(:minimal_article, 3, :published)

    @articles = assign(:articles, Article.for_public.page(1))
  end

  it "renders a list of articles" do
    render
  end
end
