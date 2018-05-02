require "rails_helper"

RSpec.describe "admin/genres/edit", type: :view do
  before(:each) do
    @admin_genre = assign(:admin_genre, Admin::Genre.create!())
  end

  it "renders the edit admin_genre form" do
    render

    assert_select "form[action=?][method=?]", admin_genre_path(@admin_genre), "post" do
    end
  end
end
