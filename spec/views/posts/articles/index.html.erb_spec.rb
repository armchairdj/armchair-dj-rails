# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/articles/index", type: :view do
  before(:each) do
    3.times { create(:minimal_article, :published) }

    @articles = assign(:articles, Article.for_public.page(1))
  end

  it "renders a list of articles" do
    render
  end
end
