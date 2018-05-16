require "rails_helper"

RSpec.describe "admin/roles/new", type: :view do
  before(:each) do
    5.times do
      create(:minimal_medium)
    end

    @model_class = assign(:model_name, Role)
    @media       = assign(:media, Medium.for_admin.alpha)
    @role        = assign(:role, build(:role))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_roles_path, "post" do
      # TODO
    end
  end
end
