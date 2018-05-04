require "rails_helper"

RSpec.describe "admin/roles/show", type: :view do
  before(:each) do
    @role = assign(:role, create(:minimal_role))
  end

  it "renders" do
    render
  end
end
