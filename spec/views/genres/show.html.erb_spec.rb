require "rails_helper"

RSpec.describe "genres/show", type: :view do
  before(:each) do
    @genre = assign(:genre, Genre.create!())
  end

  it "renders" do
    render
  end
end
