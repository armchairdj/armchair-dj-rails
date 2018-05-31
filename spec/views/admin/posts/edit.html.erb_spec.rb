# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/edit", type: :view do
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
      @model_class = assign(:model_name, Post)
    end

    context "standalone" do
      before(:each) do
        @post           = assign(:post, create(:standalone_post))
        @selected_tab   = assign(:selected_tab, "post-standalone")
        @available_tabs = assign(:available_tabs, ["post-standalone"])
      end

      context "pristine" do
        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_post_path(@post), "post" do
            assert_select("div.error-notification", { count: 0 })

            assert_select(".tab#post-choose-work", { count: 0 })
            assert_select(".tab#post-new-work",    { count: 0 })
            assert_select(".tab#post-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
            assert_select("input[name=?]",    "post[slug]")
            assert_select("input[name=?]",    "post[publish_on]")
          end
        end
      end

      context "with errors" do
        before(:each) do
          @post.summary = "too short"
          @post.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_post_path(@post), "post" do
            assert_select("div.error-notification")

            assert_select(".tab#post-choose-work", { count: 0 })
            assert_select(".tab#post-new-work",    { count: 0 })
            assert_select(".tab#post-standalone",  { count: 1 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
            assert_select("input[name=?]",    "post[slug]")
            assert_select("input[name=?]",    "post[publish_on]")
          end
        end
      end
    end

    context "review" do
      before(:each) do
        @post           = assign(:post, create(:standalone_post))
        @selected_tab   = assign(:selected_tab, "post-choose-work")
        @available_tabs = assign(:available_tabs, ["post-choose-work", "post-new-work"])
      end

      context "pristine" do
        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_post_path(@post), "post" do
            assert_select("div.error-notification", { count: 0 })

            assert_select(".tab#post-choose-work", { count: 1 })
            assert_select(".tab#post-new-work",    { count: 1 })
            assert_select(".tab#post-standalone",  { count: 0 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
            assert_select("input[name=?]",    "post[slug]")
            assert_select("input[name=?]",    "post[publish_on]")
          end
        end
      end

      context "with errors" do
        before(:each) do
          @post.summary = "too short"
          @post.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_post_path(@post), "post" do
            assert_select("div.error-notification")

            assert_select(".tab#post-choose-work", { count: 1 })
            assert_select(".tab#post-new-work",    { count: 1 })
            assert_select(".tab#post-standalone",  { count: 0 })

            assert_select("textarea[name=?]", "post[body]")
            assert_select("textarea[name=?]", "post[summary]")
            assert_select("input[name=?]",    "post[slug]")
            assert_select("input[name=?]",    "post[publish_on]")
          end
        end
      end
    end
  end
end
