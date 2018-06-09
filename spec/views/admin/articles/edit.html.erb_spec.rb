# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/articles/edit", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:tag_for_post)
    end

    @model_class = assign(:model_name, Article)
    @creators    = assign(:creators,   Creator.all.alpha)
    @media       = assign(:media,      Medium.all.alpha )
    @tags        = assign(:tags,       Tag.for_posts     )
    @article     = assign(:article,    create(:minimal_article))
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
