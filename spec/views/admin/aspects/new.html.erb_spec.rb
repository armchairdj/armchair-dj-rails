require "rails_helper"

RSpec.describe "admin/aspects/new", type: :view do
  before(:each) do
    assign(:admin_aspect, Aspect.new())
  end

  it "renders new admin_aspect form" do
    render

    assert_select "form[action=?][method=?]", admin_aspects_path, "post" do
    end
  end
end
