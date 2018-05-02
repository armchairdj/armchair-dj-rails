require "rails_helper"

RSpec.describe "admin/genres/show", type: :view do
  before(:each) do
    @genre = assign(:genre, Admin::Genre.create!())
  end

  it "renders" do
    render
  end
end
