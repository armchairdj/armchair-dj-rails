require 'rails_helper'

RSpec.describe 'admin/creators/new', type: :view do
  before(:each) do
    @creator = assign(:creator, build(:creator))
  end

  it "renders new creator form" do
    render

    assert_select "form[action=?][method=?]", admin_creators_path, "post" do
      # TODO
    end
  end
end
