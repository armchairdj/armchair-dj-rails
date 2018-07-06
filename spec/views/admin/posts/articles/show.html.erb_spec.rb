# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/articles/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Article)
    @article     = assign(:article, create(:complete_article))
    @tags        = assign(:tags,  TagsDecorator.new(@article.tags.alpha))
    @links       = assign(:links, LinksDecorator.new(@article.links))
  end

  it "renders" do
    render
  end
end
