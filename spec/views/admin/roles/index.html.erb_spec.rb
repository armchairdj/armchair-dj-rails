require "rails_helper"

RSpec.describe "admin/roles/index", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_role) }

    @model_class = assign(:model_name, Role)
    @relation    = assign(:relation, DicedRelation.new(Role.all))
    @roles       = assign(:roles, @relation.resolve)
  end

  it "renders a list of roles" do
    render
  end
end
