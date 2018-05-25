require "rails_helper"

RSpec.describe "admin/roles/index", type: :view do
  before(:each) do
    11.times do
      create(:minimal_role)
    end

    10.times do
      create(:minimal_role)
    end

    @model_class = assign(:model_name, Role)
    @scope       = assign(:scope, :for_admin)
    @sort        = assign(:sort, @model_class.default_admin_sort)
    @roles       = assign(:roles, Role.for_admin.page(1))
  end

  it "renders a list of admin/roles" do
    render
  end
end
