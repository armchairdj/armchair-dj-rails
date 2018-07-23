# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/articles/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_article) }

    @model_class = assign(:model_name, Article)
    @collection    = assign(:collection, Ginsu::Collection.new(Article.all))
    @articles    = assign(:articles, @collection.resolve)
  end

  it "renders a list of articles" do
    render
  end
end
