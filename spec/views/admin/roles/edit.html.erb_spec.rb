require "rails_helper"

RSpec.describe "admin/roles/edit", type: :view do
  login_root

  before(:each) do
    5.times do
      create(:minimal_medium)
    end

    @model_class = assign(:model_name, Role)
    @media       = assign(:media, Medium.for_admin.alpha)
    @role        = assign(:role, create(:minimal_role))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_role_path(@role), "post" do
      # TODO
    end
  end
end