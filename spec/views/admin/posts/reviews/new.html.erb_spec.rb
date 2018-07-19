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

    @model_class = assign(:model_name, Review)

    @works = assign(:works, Work.grouped_by_medium)

    @post = @review = build(:review)

    assign(:review, @review)
    assign(:post,   @review)
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
        assert_select("div.error-notification",               { count: 0 })
        assert_select("textarea[name=?]", "mixtape[body]",    { count: 0 })
        assert_select("textarea[name=?]", "mixtape[summary]", { count: 0 })
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
          assert_select("div.error-notification", { count: 1 })
        end
      end
    end
  end
end
