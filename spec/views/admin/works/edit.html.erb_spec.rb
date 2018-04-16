require "rails_helper"

RSpec.describe "admin/works/edit", type: :view do
  before(:each) do
    @model_class = assign(:model_name, Work)
    @work        = assign(:work, create(:minimal_work))
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", admin_work_path(@work), "post" do
      # TODO
    end
  end
end
