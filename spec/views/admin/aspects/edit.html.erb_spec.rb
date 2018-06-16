require "rails_helper"

RSpec.describe "admin/aspects/edit", type: :view do
  before(:each) do
    @admin_aspect = assign(:admin_aspect, Aspect.create!())
  end

  it "renders the edit admin_aspect form" do
    render

    assert_select "form[action=?][method=?]", admin_aspect_path(@admin_aspect), "post" do
    end
  end
end
