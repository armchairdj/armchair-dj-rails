require "rails_helper"

RSpec.describe "media/show", type: :view do
  before(:each) do
    @medium = assign(:medium, create(:minimal_medium, :with_published_publication))
  end

  it "renders" do
    render
  end
end
