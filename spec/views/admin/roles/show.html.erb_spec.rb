require "rails_helper"

RSpec.describe "admin/roles/show", type: :view do
  before(:each) do
    @admin_role = assign(:admin_role, Admin::Role.create!())
  end

  it "renders" do
    render
  end
end
