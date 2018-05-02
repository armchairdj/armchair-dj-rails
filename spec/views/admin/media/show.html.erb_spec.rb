require "rails_helper"

RSpec.describe "admin/media/show", type: :view do
  before(:each) do
    @medium = assign(:medium, Admin::Medium.create!())
  end

  it "renders" do
    render
  end
end
