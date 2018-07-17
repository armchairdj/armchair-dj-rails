require "rails_helper"

RSpec.describe "admin/aspects/index", type: :view do
  login_root

  let(:dummy) { Admin::AspectsController.new }

  before(:each) do
    3.times { create(:minimal_aspect) }

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Aspect)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @aspects     = assign(:aspects, Aspect.all.page(1))
  end

  it "renders a list of admin/aspects" do
    render
  end
end
