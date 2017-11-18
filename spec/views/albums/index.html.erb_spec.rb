require 'rails_helper'

RSpec.describe "albums/index", type: :view do
  before(:each) do
    assign(:albums, [
      create(:minimal_album),
      create(:minimal_album)
    ])
  end

  it "renders a list of albums" do
    render
  end
end
