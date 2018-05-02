require "rails_helper"

RSpec.describe "admin/roles/new", type: :view do
  before(:each) do
    assign(:role, Admin::Role.new())
  end

  it "renders new role form" do
    render

    assert_select "form[action=?][method=?]", roles_path, "post" do
    end
  end
end
