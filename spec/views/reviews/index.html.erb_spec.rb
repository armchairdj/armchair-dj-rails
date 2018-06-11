# frozen_string_literal: true

require "rails_helper"

RSpec.describe "reviews/index", type: :view do
  before(:each) do
    21.times do
      create(:complete_review, :published)
    end

    @reviews = assign(:reviews, Review.for_site.page(1))
  end

  it "renders a list of reviews" do
    render
  end
end
