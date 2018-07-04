# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/reviews/new", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_song)
      create(:minimal_tag)
    end

    @model_class  = assign(:model_name, Review)
    @creators     = assign(:creators,     Creator.all.alpha   )
    @works        = assign(:works,        Work.grouped_options)
    @tags         = assign(:tags,         Tag.for_admin.alpha)
    @review       = assign(:review,       build(:review))
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
        assert_select("div.error-notification", { count: 0 })

        assert_select("textarea[name=?]", "review[body]")
        assert_select("textarea[name=?]", "review[summary]")
      end
    end
  end

  context "with errors" do
    describe "blank form submitted" do
      before(:each) do
        @review.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
          assert_select("div.error-notification")

          assert_select("textarea[name=?]", "review[body]")
          assert_select("textarea[name=?]", "review[summary]")
        end
      end
    end
  end
end
