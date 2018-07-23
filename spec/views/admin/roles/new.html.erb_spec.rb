require "rails_helper"

RSpec.describe "admin/roles/new" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Role)
    @role        = assign(:role, build(:role))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_roles_path, "post" do
      # TODO
    end
  end
end
