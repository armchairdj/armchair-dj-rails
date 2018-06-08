require "rails_helper"

RSpec.describe "admin/media/new", type: :view do
  login_root

  before(:each) do
    5.times do
      create(:minimal_category)
    end

    @model_class = assign(:model_name, Medium)
    @medium      = assign(:medium, build(:medium))
    @categories  = assign(:categories, Category.for_admin.alpha)
  end

  it "renders new medium form" do
    render

    assert_select "form[action=?][method=?]", admin_media_path, "article" do
    end
  end
end
