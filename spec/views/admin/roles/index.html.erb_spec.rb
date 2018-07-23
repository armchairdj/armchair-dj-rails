require "rails_helper"

RSpec.describe "admin/roles/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_role) }

    @model_class = assign(:model_name, Role)
    @collection    = assign(:collection, Ginsu::Collection.new(Role.all))
    @roles       = assign(:roles, @collection.resolve)
  end

  it "renders a list of roles" do
    render
  end
end
