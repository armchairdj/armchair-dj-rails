require "rails_helper"

RSpec.describe "admin/aspects/new", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Aspect)
    @aspect      = assign(:aspect, build(:aspect))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_aspects_path, "post" do
      # TODO
    end
  end
end
