require "rails_helper"

RSpec.describe "admin/media/new", type: :view do
  before(:each) do
    assign(:medium, build(:medium))
  end

  it "renders new medium form" do
    render

    assert_select "form[action=?][method=?]", admin_media_path, "post" do
    end
  end
end
