# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/reviews/show" do
  before(:each) do
    @review = assign(:review, create(:complete_review))
  end

  it "renders" do
    render
  end
end
