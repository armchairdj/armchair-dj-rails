# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/new", type: :view do
  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_medium)
      create(:minimal_work)
      create(:tag_for_post)
    end

    @creators = assign(:creators, Creator.all.alpha    )
    @media    = assign(:media,    Medium.select_options)
    @works    = assign(:works,    Work.grouped_options )
  end

  context "initial state" do
    before(:each) do
      @model_class    = assign(:model_name, Post)
      @post           = assign(:post, build(:post))
      @selected_tab   = assign(:selected_tab, "post-choose-work")
      @available_tabs = assign(:available_tabs, ["post-choose-work", "post-new-work", "post-standalone"])
    end

    context "pristine" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_posts_path, "post" do
          assert_select("div.error-notification", { count: 0 })

          assert_select(".tab#post-choose-work", { count: 1 })
          assert_select(".tab#post-new-work",    { count: 1 })
          assert_select(".tab#post-standalone",  { count: 1 })

          assert_select("textarea[name=?]", "post[body]")
          assert_select("textarea[name=?]", "post[summary]")
        end
      end
    end

    context "with errors" do
      context "blank form submitted" do
        before(:each) do
          @post.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_posts_path, "post" do
            assert_select("div.error-notification") do
              assert_select("div.error")
            end

            assert_select(".tab#post-choose-work", { count: 1 })
            assert_select(".tab#post-new-work",    { count: 1 })
            assert_select(".tab#post-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
          end
        end
      end

      context "standalone" do
        before(:each) do
          @post.title   = "Standalone"
          @post.summary = "too short"
          @post.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_posts_path, "post" do
            assert_select("div.error-notification")

            assert_select(".tab#post-choose-work", { count: 1 })
            assert_select(".tab#post-new-work",    { count: 1 })
            assert_select(".tab#post-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
          end
        end
      end

      context "review of existing work" do
        before(:each) do
          @post.work_id = create(:minimal_work).id
          @post.summary = "too short"
          @post.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_posts_path, "post" do
            assert_select("div.error-notification")

            assert_select(".tab#post-choose-work", { count: 1 })
            assert_select(".tab#post-new-work",    { count: 1 })
            assert_select(".tab#post-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
          end
        end
      end

      context "review of new work" do
        before(:each) do
          @post.work_attributes = attributes_for(:work, :with_medium, :with_title)
          @post.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_posts_path, "post" do
            assert_select("div.error-notification")

            assert_select(".tab#post-choose-work", { count: 1 })
            assert_select(".tab#post-new-work",    { count: 1 })
            assert_select(".tab#post-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
          end
        end
      end
    end
  end
end
