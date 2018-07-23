# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/reviews/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_review) }

    @model_class = assign(:model_name, Review)
    @collection    = assign(:collection, Ginsu::Collection.new(Review.all))
    @reviews     = assign(:reviews, @collection.resolve)
  end

  it "renders a list of reviews" do
    render
  end
end
