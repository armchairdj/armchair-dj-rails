# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/users/new" do
  login_root

  before do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, build(:user))
    @roles       = assign(:roles, create(:root).assignable_role_options)
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", admin_users_path, "post" do
    end
  end
end
