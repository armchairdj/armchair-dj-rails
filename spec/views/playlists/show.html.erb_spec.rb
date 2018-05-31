require "rails_helper"

RSpec.describe "playlists/show", type: :view do
  before(:each) do
    @playlist = assign(:playlist, Playlist.create!())
  end

  it "renders" do
    render
  end
end
