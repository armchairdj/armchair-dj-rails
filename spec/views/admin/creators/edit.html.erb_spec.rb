require "rails_helper"

RSpec.describe 'admin/creators/edit', type: :view do
  before(:each) do
    @model_class = assign(:model_name, Creator)
    @creator     = assign(:creator, create(:minimal_creator))
  end

  it "renders edit creator form" do
    render

    assert_select "form[action=?][method=?]", admin_creator_path(@creator), "post" do
      # TODO
    end
  end
end
