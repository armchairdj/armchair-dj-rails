require "rails_helper"

RSpec.describe "admin/tags/edit", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Tag)
    @tag         = assign(:tag, create(:minimal_tag, :with_published_post))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_tag_path(@tag), "post" do
      # TODO
    end
  end
end
