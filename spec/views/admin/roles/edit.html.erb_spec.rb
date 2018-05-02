require "rails_helper"

RSpec.describe "admin/roles/edit", type: :view do
  before(:each) do
    @role = assign(:role, Admin::Role.create!())
  end

  it "renders the edit role form" do
    render

    assert_select "form[action=?][method=?]", role_path(@role), "post" do
    end
  end
end