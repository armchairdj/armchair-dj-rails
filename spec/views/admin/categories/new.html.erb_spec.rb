require "rails_helper"

RSpec.describe "admin/categories/new", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Category)
    @category    = assign(:category, build(:category))
  end

  it "renders new category form" do
    render

    assert_select "form[action=?][method=?]", admin_categories_path, "article" do
    end
  end
end
