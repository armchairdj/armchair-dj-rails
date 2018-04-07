require 'rails_helper'

RSpec.describe 'admin/works/new', type: :view do
  before(:each) do
    assign(:work, build(:work))
  end

  it "renders new work form" do
    render

    assert_select "form[action=?][method=?]", admin_works_path, "post" do
      # TODO
    end
  end
end
