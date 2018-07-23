# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/reviews/show" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Review)
    @review      = assign(:review, create(:complete_review, :published))
    @tags        = assign(:tags, @review.tags.alpha)
    @links       = assign(:links, @review.links)
  end

  it "renders" do
    render
  end
end
