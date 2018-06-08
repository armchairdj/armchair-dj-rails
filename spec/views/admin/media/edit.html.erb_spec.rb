require "rails_helper"

RSpec.describe "admin/media/edit", type: :view do
  login_root

  before(:each) do
    5.times do
      create(:minimal_category)
    end

    @model_class = assign(:model_name, Medium)
    @medium      = assign(:medium, create(:minimal_medium))
    @categories  = assign(:categories, Category.for_admin.alpha)
  end

  it "renders the edit medium form" do
    render

    assert_select "form[action=?][method=?]", admin_medium_path(@medium), "article" do
    end
  end
end
