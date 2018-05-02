require "rails_helper"

RSpec.describe "admin/media/index", type: :view do
  before(:each) do
    assign(:media, [
      Admin::Medium.create!(),
      Admin::Medium.create!()
    ])
  end

  it "renders a list of admin/media" do
    render
  end
end
