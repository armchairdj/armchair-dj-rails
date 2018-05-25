require "rails_helper"

RSpec.describe "admin/users/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_user, :with_published_post)
    end

    @model_class = assign(:model_name, User)
    @scope       = assign(:scope, :for_admin)
    @sort        = assign(:sort, @model_class.default_admin_sort)
    @users       = assign(:users, User.for_admin.page(1))
  end

  it "renders a list of admin/users" do
    render
  end
end
