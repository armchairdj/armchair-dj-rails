require "rails_helper"

RSpec.describe "admin/playlists/show", type: :view do
  before(:each) do
    @admin_playlist = assign(:admin_playlist, Playlist.create!())
  end

  it "renders" do
    render
  end
end
