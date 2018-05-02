require "rails_helper"

RSpec.describe "admin/roles/index", type: :view do
  before(:each) do
    assign(:roles, [
      Admin::Role.create!(),
      Admin::Role.create!()
    ])
  end

  it "renders a list of admin/roles" do
    render
  end
end
