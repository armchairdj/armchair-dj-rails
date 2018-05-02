require "rails_helper"

RSpec.describe "admin/media/new", type: :view do
  before(:each) do
    assign(:admin_medium, Admin::Medium.new())
  end

  it "renders new admin_medium form" do
    render

    assert_select "form[action=?][method=?]", admin_media_path, "post" do
    end
  end
end
