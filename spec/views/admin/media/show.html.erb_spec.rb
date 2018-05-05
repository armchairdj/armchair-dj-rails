require "rails_helper"

RSpec.describe "admin/media/show", type: :view do
  before(:each) do
    @model_class = assign(:model_name, Medium)
    @medium      = assign(:medium, create(:minimal_medium, :with_published_post))
  end

  it "renders" do
    render
  end
end
