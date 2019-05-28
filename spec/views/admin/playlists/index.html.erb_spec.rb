# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/playlists/index" do
  login_root

  before do
    create_list(:minimal_playlist, 3)

    @model_class = assign(:model_name, Playlist)
    @collection = assign(:collection, Ginsu::Collection.new(Playlist.all))
    @playlists = assign(:playlists, @collection.resolved)
  end

  it "renders a list of playlists" do
    render
  end
end
