# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/reviews/index", type: :view do
  before(:each) do
    3.times { create(:complete_review, :published) }

    @reviews = assign(:reviews, Review.for_public.page(1))
  end

  it "renders a list of reviews" do
    render
  end
end
