# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/reviews/index" do
  before do
    create_list(:minimal_review, 3, :published)

    @reviews = assign(:reviews, Review.for_public.page(1))
  end

  it "renders a list of reviews" do
    render
  end
end
