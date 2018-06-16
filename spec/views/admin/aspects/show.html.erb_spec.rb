require "rails_helper"

RSpec.describe "admin/aspects/show", type: :view do
  before(:each) do
    @admin_aspect = assign(:admin_aspect, Aspect.create!())
  end

  it "renders" do
    render
  end
end
