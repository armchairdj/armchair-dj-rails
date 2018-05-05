require "rails_helper"

RSpec.describe "admin/users/new", type: :view do
  before(:each) do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, build(:user))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", admin_users_path, "post" do
    end
  end
end
