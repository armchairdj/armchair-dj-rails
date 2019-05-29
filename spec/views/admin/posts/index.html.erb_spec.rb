# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/index" do
  login_root

  context "with article" do
    before do
      @view_path   = assign(:view_path, "articles")
      @model_class = assign(:model_name, Article)

      create_list(:minimal_article, 3)

      @collection = assign(:collection, Ginsu::Collection.new(Article.all))
      @articles   = assign(:articles, @collection.resolved)

      allow(controller).to receive(:params).and_return(
        action:     "index",
        controller: "admin/posts/articles",
        page:       nil
      )
    end

    it "renders a list of articles" do
      render
    end
  end

  context "with mixtape" do
    before do
      @view_path   = assign(:view_path, "mixtapes")
      @model_class = assign(:model_name, Mixtape)

      create_list(:minimal_mixtape, 3)

      @collection = assign(:collection, Ginsu::Collection.new(Mixtape.all))
      @mixtapes   = assign(:mixtapes, @collection.resolved)

      allow(controller).to receive(:params).and_return(
        action:     "index",
        controller: "admin/posts/mixtapes",
        page:       nil
      )
    end

    it "renders a list of mixtapes" do
      render
    end
  end

  context "with review" do
    before do
      @view_path   = assign(:view_path, "reviews")
      @model_class = assign(:model_name, Review)

      create_list(:minimal_review, 3)

      @collection = assign(:collection, Ginsu::Collection.new(Review.all))
      @reviews    = assign(:reviews, @collection.resolved)

      allow(controller).to receive(:params).and_return(
        action:     "index",
        controller: "admin/posts/reviews",
        page:       nil
      )
    end

    it "renders a list of reviews" do
      render
    end
  end
end
