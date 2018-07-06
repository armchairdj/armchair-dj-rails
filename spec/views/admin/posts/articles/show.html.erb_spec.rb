# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/articles/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Article)
    @article     = assign(:article, create(:complete_article))
    @tags        = assign(:tags, @article.tags.alpha.decorate)
    @links       = assign(:links, @article.links.decorate)
  end

  it "renders" do
    render
  end
end
