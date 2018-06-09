require "rails_helper"

RSpec.describe "admin/tags/new", type: :view do
  login_root

  before(:each) do
    5.times do
      create(:minimal_category)
    end

    @model_class = assign(:model_name, Tag)
    @tag         = assign(:tag, build(:tag))
    @categories  = assign(:categories, Category.for_admin.alpha)
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_tags_path, "post" do
      # TODO
    end
  end
end
