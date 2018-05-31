require "rails_helper"

RSpec.describe "admin/categories/index", type: :view do
  login_root

  let(:dummy) { Admin::CategoriesController.new }

  before(:each) do
    21.times do
      create(:minimal_category)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Category)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @categories  = assign(:categories, Category.for_admin.page(1))
  end

  it "renders a list of admin/categories" do
    render
  end
end
