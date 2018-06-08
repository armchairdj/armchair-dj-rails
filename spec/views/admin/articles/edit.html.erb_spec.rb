# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/articles/edit", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_medium)
      create(:minimal_work)
      create(:tag_for_post)
    end

    @creators = assign(:creators, Creator.all.alpha   )
    @media    = assign(:media,    Medium.all.alpha    )
    @works    = assign(:works,    Work.grouped_options)
  end

  context "for standalone" do
    before(:each) do
      @model_class = assign(:model_name, Article)
    end

    context "standalone" do
      before(:each) do
        @article           = assign(:article, create(:minimal_article))
        @selected_tab   = assign(:selected_tab, "article-standalone")
      end

      context "pristine" do
        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_article_path(@article), "article" do
            assert_select("div.error-notification", { count: 0 })

            assert_select(".tab#article-choose-work", { count: 0 })
            assert_select(".tab#article-new-work",    { count: 0 })
            assert_select(".tab#article-standalone",  { count: 1 })

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

          assert_select "form[action=?][method=?]", admin_article_path(@article), "article" do
            assert_select("div.error-notification")

            assert_select(".tab#article-choose-work", { count: 0 })
            assert_select(".tab#article-new-work",    { count: 0 })
            assert_select(".tab#article-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "article[body]")
            assert_select("textarea[name=?]", "article[summary]")
            assert_select("input[name=?]",    "article[slug]")
            assert_select("input[name=?]",    "article[publish_on]")
          end
        end
      end
    end

    context "review" do
      before(:each) do
        @article           = assign(:article, create(:minimal_article))
        @selected_tab   = assign(:selected_tab, "article-choose-work")
      end

      context "pristine" do
        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_article_path(@article), "article" do
            assert_select("div.error-notification", { count: 0 })

            assert_select(".tab#article-choose-work", { count: 1 })
            assert_select(".tab#article-new-work",    { count: 1 })
            assert_select(".tab#article-standalone",  { count: 0 })

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

          assert_select "form[action=?][method=?]", admin_article_path(@article), "article" do
            assert_select("div.error-notification")

            assert_select(".tab#article-choose-work", { count: 1 })
            assert_select(".tab#article-new-work",    { count: 1 })
            assert_select(".tab#article-standalone",  { count: 0 })

            assert_select("textarea[name=?]", "article[body]")
            assert_select("textarea[name=?]", "article[summary]")
            assert_select("input[name=?]",    "article[slug]")
            assert_select("input[name=?]",    "article[publish_on]")
          end
        end
      end
    end
  end
end
