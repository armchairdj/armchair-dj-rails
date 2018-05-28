require "rails_helper"

RSpec.describe "admin/users/edit", type: :view do
  before(:each) do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, create(:minimal_user, :with_published_post))
    @roles       = assign(:roles, create(:root).assignable_role_options)
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", admin_user_path(@user), "post" do
    end
  end
end
