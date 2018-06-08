require "rails_helper"

RSpec.describe "admin/categories/edit", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Category)
    @category    = assign(:category, create(:minimal_category))
  end

  it "renders the edit category form" do
    render

    assert_select "form[action=?][method=?]", admin_category_path(@category), "article" do
    end
  end
end
