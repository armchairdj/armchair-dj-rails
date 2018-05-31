require "rails_helper"

RSpec.describe "admin/media/index", type: :view do
  login_root

  let(:dummy) { Admin::MediaController.new }

  before(:each) do
    21.times do
      create(:minimal_medium, :with_published_post)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Medium)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @media       = assign(:media, Medium.for_admin.page(1))
  end

  it "renders a list of admin/media" do
    render
  end
end
