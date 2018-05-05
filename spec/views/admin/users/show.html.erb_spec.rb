require "rails_helper"

RSpec.describe "admin/users/show", type: :view do
  before(:each) do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, create(:minimal_user, :with_published_post))
  end

  it "renders" do
    render
  end
end
