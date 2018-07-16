# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/articles/new", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_tag) }

    @model_class = assign(:model_name, Article)

    @tags = assign(:tags, Tag.for_admin.alpha)

    @post = @article = build(:article)

    assign(:review, @article)
    assign(:post,   @article)
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_articles_path, "post" do
        assert_select("div.error-notification", { count: 0 })

        assert_select("textarea[name=?]", "article[body]")
        assert_select("textarea[name=?]", "article[summary]")
      end
    end
  end

  context "with errors" do
    describe "blank form submitted" do
      before(:each) do
        @article.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_articles_path, "post" do
          assert_select("div.error-notification", { count: 1 })

          assert_select("textarea[name=?]", "article[body]")
          assert_select("textarea[name=?]", "article[summary]")
        end
      end
    end
  end
end
