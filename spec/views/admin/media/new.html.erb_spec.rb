require "rails_helper"

RSpec.describe "admin/media/new", type: :view do
  before(:each) do
    assign(:medium, Medium.new())
  end

  it "renders new medium form" do
    render

    assert_select "form[action=?][method=?]", media_path, "post" do
    end
  end
end
