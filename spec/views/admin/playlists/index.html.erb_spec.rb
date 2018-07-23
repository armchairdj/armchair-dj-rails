require "rails_helper"

RSpec.describe "admin/playlists/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_playlist) }

    @model_class = assign(:model_name, Playlist)
    @collection    = assign(:collection, Ginsu::Collection.new(Playlist.all))
    @playlists   = assign(:playlists, @collection.resolve)
  end

  it "renders a list of playlists" do
    render
  end
end
