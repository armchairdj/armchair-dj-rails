require "rails_helper"

RSpec.describe "admin/users/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, create(:root, :with_published_post, :with_links))
    @links       = assign(:links, @user.links.decorate)
  end

  it "renders" do
    render
  end
end
