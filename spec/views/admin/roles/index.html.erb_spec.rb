require "rails_helper"

RSpec.describe "admin/roles/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_role)
    end

    @model_class = assign(:model_name, Role)
    @roles       = assign(:roles, Role.for_admin.page(1))
  end

  it "renders a list of admin/roles" do
    render
  end
end
