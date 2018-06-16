require "rails_helper"

RSpec.describe "admin/aspects/index", type: :view do
  before(:each) do
    assign(:aspects, [
      Aspect.create!(),
      Aspect.create!()
    ])
  end

  it "renders a list of admin/aspects" do
    render
  end
end
