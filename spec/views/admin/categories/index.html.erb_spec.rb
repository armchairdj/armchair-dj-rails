require "rails_helper"

RSpec.describe "admin/categories/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_category)
    end

    @model_class = assign(:model_name, Category)
    @scope       = assign(:scope, :for_admin)
    @sort        = assign(:sort, @model_class.default_admin_sort)
    @categories  = assign(:categories, Category.for_admin.page(1))
  end

  it "renders a list of admin/categories" do
    render
  end
end
