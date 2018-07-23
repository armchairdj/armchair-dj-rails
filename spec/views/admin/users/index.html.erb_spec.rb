require "rails_helper"

RSpec.describe "admin/users/index", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_user) }

    @model_class = assign(:model_name, User)
    @relation    = assign(:relation, DicedRelation.new(User.all))
    @users       = assign(:users, @relation.resolve)
  end

  it "renders a list of users" do
    render
  end
end
