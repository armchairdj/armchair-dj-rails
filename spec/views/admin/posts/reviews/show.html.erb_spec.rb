# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/reviews/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Review)
    @review      = assign(:review, create(:minimal_review, :published))
  end

  it "renders" do
    render
  end
end
