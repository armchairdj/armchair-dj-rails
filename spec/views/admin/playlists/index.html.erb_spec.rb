require "rails_helper"

RSpec.describe "admin/playlists/index", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_playlist) }

    @model_class = assign(:model_name, Playlist)
    @relation    = assign(:relation, DicedRelation.new(Playlist.all))
    @playlists   = assign(:playlists, @relation.resolve)
  end

  it "renders a list of playlists" do
    render
  end
end
