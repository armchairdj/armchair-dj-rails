# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/reviews/edit", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_medium)
      create(:minimal_song)
      create(:minimal_tag)
    end

    @model_class  = assign(:model_name, Review)
    @creators     = assign(:creators,     Creator.all.alpha   )
    @media        = assign(:media,        Medium.all.alpha    )
    @works        = assign(:works,        Work.grouped_options)
    @tags         = assign(:tags,         Tag.for_admin.alpha)
    @review       = assign(:review,       create(:minimal_review))
    @selected_tab = assign(:selected_tab, "review-choose-work")
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_review_path(@review), "post" do
        assert_select("div.error-notification", { count: 0 })

        assert_select(".tab#review-choose-work", { count: 1 })
        assert_select(".tab#review-new-work",    { count: 1 })

        assert_select("textarea[name=?]", "review[body]")
        assert_select("textarea[name=?]", "review[summary]")
        assert_select("input[name=?]",    "review[slug]")
        assert_select("input[name=?]",    "review[publish_on]")
      end
    end
  end

  context "with errors" do
    before(:each) do
      @review.summary = "too short"
      @review.valid?
    end

    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_review_path(@review), "post" do
        assert_select("div.error-notification", { count: 1 })

        assert_select(".tab#review-choose-work", { count: 1 })
        assert_select(".tab#review-new-work",    { count: 1 })

        assert_select("textarea[name=?]", "review[body]")
        assert_select("textarea[name=?]", "review[summary]")
        assert_select("input[name=?]",    "review[slug]")
        assert_select("input[name=?]",    "review[publish_on]")
      end
    end
  end
end
