require "rails_helper"

RSpec.describe "admin/tags/index", type: :view do
  let(:dummy) { Admin::TagsController.new }

  before(:each) do
    11.times do
      create(:minimal_tag, :with_published_post)
    end

    10.times do
      create(:minimal_tag, :with_viewable_work)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Tag)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @tags        = assign(:tags, Tag.for_admin.page(1))
  end

  it "renders a list of admin/tags" do
    render
  end
end
