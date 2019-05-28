# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/show" do
  login_root

  context "article" do
    before do
      @view_path   = assign(:view_path, "articles")
      @model_class = assign(:model_name, Article)
      @article     = create(:complete_article, :published)

      assign(:article, @article)
      assign(:post,    @article)
    end

    it "renders" do
      render
    end
  end

  context "mixtape" do
    before do
      @view_path   = assign(:view_path, "mixtapes")
      @model_class = assign(:model_name, Mixtape)
      @mixtape     = create(:complete_mixtape, :published)

      assign(:mixtape, @mixtape)
      assign(:post,    @mixtape)
    end

    it "renders" do
      render
    end
  end

  context "review" do
    before do
      @view_path   = assign(:view_path, "reviews")
      @model_class = assign(:model_name, Review)
      @review      = create(:complete_review, :published)

      assign(:review, @review)
      assign(:post,   @review)
    end

    it "renders" do
      render
    end
  end
end
