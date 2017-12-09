require 'rails_helper'

RSpec.describe 'songs/index', type: :view do
  before(:each) do
    assign(:songs, [
      create(:minimal_song),
      create(:minimal_song)
    ])
  end

  it "renders a list of songs" do
    render
  end
end
