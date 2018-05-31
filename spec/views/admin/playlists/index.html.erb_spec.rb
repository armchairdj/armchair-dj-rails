require "rails_helper"

RSpec.describe "admin/playlists/index", type: :view do
  before(:each) do
    assign(:playlists, [
      Playlist.create!(),
      Playlist.create!()
    ])
  end

  it "renders a list of admin/playlists" do
    render
  end
end
