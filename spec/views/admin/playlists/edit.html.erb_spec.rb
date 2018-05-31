require "rails_helper"

RSpec.describe "admin/playlists/edit", type: :view do
  before(:each) do
    @admin_playlist = assign(:admin_playlist, Playlist.create!())
  end

  it "renders the edit admin_playlist form" do
    render

    assert_select "form[action=?][method=?]", admin_playlist_path(@admin_playlist), "post" do
    end
  end
end
