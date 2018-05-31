require "rails_helper"

RSpec.describe "admin/categories/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Category)
    @category    = assign(:category, create(:minimal_category))
  end

  it "renders" do
    render
  end
end
