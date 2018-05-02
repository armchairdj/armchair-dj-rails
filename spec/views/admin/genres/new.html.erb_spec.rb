require "rails_helper"

RSpec.describe "admin/genres/new", type: :view do
  before(:each) do
    assign(:admin_genre, Admin::Genre.new())
  end

  it "renders new admin_genre form" do
    render

    assert_select "form[action=?][method=?]", admin_genres_path, "post" do
    end
  end
end
