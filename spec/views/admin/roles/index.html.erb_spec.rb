require "rails_helper"

RSpec.describe "admin/roles/index", type: :view do
  let(:dummy) { Admin::RolesController.new }

  before(:each) do
    11.times do
      create(:minimal_role)
    end

    10.times do
      create(:minimal_role)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Role)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @roles       = assign(:roles, Role.for_admin.page(1))
  end

  it "renders a list of admin/roles" do
    render
  end
end
