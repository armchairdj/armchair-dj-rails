# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/reviews/new", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_medium)
      create(:minimal_work)
      create(:tag_for_post)
    end

    @model_class  = assign(:model_name, Review)
    @creators     = assign(:creators,     Creator.all.alpha   )
    @media        = assign(:media,        Medium.all.alpha    )
    @works        = assign(:works,        Work.grouped_options)
    @tags         = assign(:tags,         Tag.for_posts)
    @review       = assign(:review,       build(:review))
    @selected_tab = assign(:selected_tab, "review-choose-work")
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
        assert_select("div.error-notification", { count: 0 })

        assert_select(".tab#review-choose-work", { count: 1 })
        assert_select(".tab#review-new-work",    { count: 1 })

        assert_select("textarea[name=?]", "review[body]")
        assert_select("textarea[name=?]", "review[summary]")
      end
    end
  end

  context "with errors" do
    context "blank form submitted" do
      before(:each) do
        @review.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
          assert_select("div.error-notification")

          assert_select(".tab#review-choose-work", { count: 1 })
          assert_select(".tab#review-new-work",    { count: 1 })

          assert_select("textarea[name=?]", "review[body]")
          assert_select("textarea[name=?]", "review[summary]")
        end
      end
    end

    context "review of existing work" do
      before(:each) do
        @review.work_id = create(:minimal_work).id
        @review.summary = "too short"
        @review.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
          assert_select("div.error-notification")

          assert_select(".tab#review-choose-work", { count: 1 })
          assert_select(".tab#review-new-work",    { count: 1 })

          assert_select("textarea[name=?]", "review[body]")
          assert_select("textarea[name=?]", "review[summary]")
        end
      end
    end

    context "review of new work" do
      before(:each) do
        @review.work_attributes = attributes_for(:work, :with_existing_medium, :with_title)
        @review.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
          assert_select("div.error-notification")

          assert_select(".tab#review-choose-work", { count: 1 })
          assert_select(".tab#review-new-work",    { count: 1 })

          assert_select("textarea[name=?]", "review[body]")
          assert_select("textarea[name=?]", "review[summary]")
        end
      end
    end
  end
end
