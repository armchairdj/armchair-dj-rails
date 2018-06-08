# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/articles/new", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_medium)
      create(:minimal_work)
      create(:tag_for_item)
    end

    @creators = assign(:creators, Creator.all.alpha   )
    @media    = assign(:media,    Medium.all.alpha    )
    @works    = assign(:works,    Work.grouped_options)
  end

  context "initial state" do
    before(:each) do
      @model_class    = assign(:model_name, Article)
      @article           = assign(:article, build(:article))
      @selected_tab   = assign(:selected_tab, "article-choose-work")
      @available_tabs = assign(:available_tabs, ["article-choose-work", "article-new-work", "article-standalone"])
    end

    context "pristine" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_articles_path, "article" do
          assert_select("div.error-notification", { count: 0 })

          assert_select(".tab#article-choose-work", { count: 1 })
          assert_select(".tab#article-new-work",    { count: 1 })
          assert_select(".tab#article-standalone",  { count: 1 })

          assert_select("textarea[name=?]", "article[body]")
          assert_select("textarea[name=?]", "article[summary]")
        end
      end
    end

    context "with errors" do
      context "blank form submitted" do
        before(:each) do
          @article.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_articles_path, "article" do
            assert_select("div.error-notification") do
              assert_select("div.error")
            end

            assert_select(".tab#article-choose-work", { count: 1 })
            assert_select(".tab#article-new-work",    { count: 1 })
            assert_select(".tab#article-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "article[body]")
            assert_select("textarea[name=?]", "article[summary]")
          end
        end
      end

      context "standalone" do
        before(:each) do
          @article.title   = "Standalone"
          @article.summary = "too short"
          @article.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_articles_path, "article" do
            assert_select("div.error-notification")

            assert_select(".tab#article-choose-work", { count: 1 })
            assert_select(".tab#article-new-work",    { count: 1 })
            assert_select(".tab#article-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "article[body]")
            assert_select("textarea[name=?]", "article[summary]")
          end
        end
      end

      context "review of existing work" do
        before(:each) do
          @article.work_id = create(:minimal_work).id
          @article.summary = "too short"
          @article.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_articles_path, "article" do
            assert_select("div.error-notification")

            assert_select(".tab#article-choose-work", { count: 1 })
            assert_select(".tab#article-new-work",    { count: 1 })
            assert_select(".tab#article-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "article[body]")
            assert_select("textarea[name=?]", "article[summary]")
          end
        end
      end

      context "review of new work" do
        before(:each) do
          @article.work_attributes = attributes_for(:work, :with_existing_medium, :with_title)
          @article.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_articles_path, "article" do
            assert_select("div.error-notification")

            assert_select(".tab#article-choose-work", { count: 1 })
            assert_select(".tab#article-new-work",    { count: 1 })
            assert_select(".tab#article-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "article[body]")
            assert_select("textarea[name=?]", "article[summary]")
          end
        end
      end
    end
  end
end
