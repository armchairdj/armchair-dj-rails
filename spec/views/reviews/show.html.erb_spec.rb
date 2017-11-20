require 'rails_helper'

RSpec.describe "reviews/show", type: :view do
  before(:each) do
    @review = assign(:review, create(:minimal_review))
  end

  it "renders attributes in <p>" do
    render
  end
end
