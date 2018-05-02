require "rails_helper"

RSpec.describe "admin/media/edit", type: :view do
  before(:each) do
    @admin_medium = assign(:admin_medium, Admin::Medium.create!())
  end

  it "renders the edit admin_medium form" do
    render

    assert_select "form[action=?][method=?]", admin_medium_path(@admin_medium), "post" do
    end
  end
end
