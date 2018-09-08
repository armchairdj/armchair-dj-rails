# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/index" do
  login_root

  context "article" do
    before(:each) do
      @view_path   = assign(:view_path, "articles")
      @model_class = assign(:model_name, Article)

      3.times { create(:minimal_article) }

      @collection = assign(:collection, Ginsu::Collection.new(Article.all))
      @articles   = assign(:articles, @collection.resolve)
    end

    it "renders a list of articles" do
      render
    end
  end

  context "mixtape" do
    before(:each) do
      @view_path   = assign(:view_path, "mixtapes")
      @model_class = assign(:model_name, Mixtape)

      3.times { create(:minimal_mixtape) }

      @collection = assign(:collection, Ginsu::Collection.new(Mixtape.all))
      @mixtapes   = assign(:mixtapes, @collection.resolve)
    end

    it "renders a list of mixtapes" do
      render
    end
  end

  context "review" do
    before(:each) do
      @view_path   = assign(:view_path, "reviews")
      @model_class = assign(:model_name, Review)

      3.times { create(:minimal_review) }

      @collection = assign(:collection, Ginsu::Collection.new(Review.all))
      @reviews    = assign(:reviews, @collection.resolve)
    end

    it "renders a list of reviews" do
      render
    end
  end
end
