require "rails_helper"

RSpec.describe "admin/genres/index", type: :view do
  before(:each) do
    assign(:admin_genres, [
      Admin::Genre.create!(),
      Admin::Genre.create!()
    ])
  end

  it "renders a list of admin/genres" do
    render
  end
end
