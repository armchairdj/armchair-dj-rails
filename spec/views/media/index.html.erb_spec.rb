require "rails_helper"

RSpec.describe "media/index", type: :view do
  before(:each) do
    assign(:media, [
      create(:minimal_medium),
      create(:minimal_medium)
    ])
  end

  it "renders a list of media" do
    render
  end
end
