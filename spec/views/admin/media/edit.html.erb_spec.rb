require "rails_helper"

RSpec.describe "admin/media/edit", type: :view do
  before(:each) do
    @medium = assign(:medium, Admin::Medium.create!())
  end

  it "renders the edit medium form" do
    render

    assert_select "form[action=?][method=?]", medium_path(@medium), "post" do
    end
  end
end
