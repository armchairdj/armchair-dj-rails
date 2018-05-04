require "rails_helper"

RSpec.describe "admin/media/edit", type: :view do
  before(:each) do
    @model_class = assign(:model_name, Medium)
    @medium      = assign(:medium, create(:minimal_medium))
  end

  it "renders the edit medium form" do
    render

    assert_select "form[action=?][method=?]", admin_medium_path(@medium), "post" do
    end
  end
end
