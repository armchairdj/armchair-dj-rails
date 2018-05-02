require "rails_helper"

RSpec.describe "media/show", type: :view do
  before(:each) do
    @medium = assign(:medium, Medium.create!())
  end

  it "renders" do
    render
  end
end
