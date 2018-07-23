require "rails_helper"

RSpec.describe "admin/aspects/show" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Aspect)
    @aspect      = assign(:aspect, create(:minimal_aspect, :with_published_post))
  end

  it "renders" do
    render
  end
end
