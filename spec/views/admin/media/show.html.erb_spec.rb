require "rails_helper"

RSpec.describe "admin/media/show", type: :view do
  before(:each) do
    @model_class = assign(:model_name, Medium)
    @medium      = assign(:medium, create(:minimal_medium))
  end

  it "renders" do
    render
  end
end
