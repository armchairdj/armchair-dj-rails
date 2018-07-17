# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/articles/edit", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_tag) }

    @model_class = assign(:model_name, Article)

    @tags = assign(:tags, Tag.all.alpha)

    @post = @article = create(:minimal_article)

    assign(:review, @article)
    assign(:post,   @article)
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_article_path(@article), "post" do
        assert_select("div.error-notification", { count: 0 })

        assert_select("textarea[name=?]", "article[body]")
        assert_select("textarea[name=?]", "article[summary]")
        assert_select("input[name=?]",    "article[slug]")
        assert_select("input[name=?]",    "article[publish_on]")
      end
    end
  end

  context "with errors" do
    before(:each) do
      @article.summary = "too short"
      @article.valid?
    end

    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_article_path(@article), "post" do
        assert_select("div.error-notification")

        assert_select("textarea[name=?]", "article[body]")
        assert_select("textarea[name=?]", "article[summary]")
        assert_select("input[name=?]",    "article[slug]")
        assert_select("input[name=?]",    "article[publish_on]")
      end
    end
  end
end
