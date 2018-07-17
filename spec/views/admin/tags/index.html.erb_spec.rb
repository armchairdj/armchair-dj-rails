require "rails_helper"

RSpec.describe "admin/tags/index", type: :view do
  login_root

  let(:dummy) { Admin::TagsController.new }

  before(:each) do
    3.times { create(:minimal_tag) }

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Tag)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @tags        = assign(:tags, Tag.all.page(1))
  end

  it "renders a list of admin/tags" do
    render
  end
end
