require "rails_helper"

RSpec.describe "media/index", type: :view do
  before(:each) do
    assign(:media, [
      Medium.create!(),
      Medium.create!()
    ])
  end

  it "renders a list of media" do
    render
  end
end
