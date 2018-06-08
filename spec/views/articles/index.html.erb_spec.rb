# frozen_string_literal: true

require "rails_helper"

RSpec.describe "articles/index", type: :view do
  before(:each) do
    10.times do
      create(:complete_article, :published)
    end

    11.times do
      create(:complete_review, :published)
    end

    @articles = assign(:articles, Article.for_site.page(1))
  end

  it "renders a list of works" do
    render
  end
end
