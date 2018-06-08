# frozen_string_literal: true

require "rails_helper"

RSpec.describe "articles/index", type: :view do
  before(:each) do
    21.times do
      create(:complete_article, :published)
    end

    @articles = assign(:articles, Article.for_site.page(1))
  end

  it "renders a list of articles" do
    render
  end
end
