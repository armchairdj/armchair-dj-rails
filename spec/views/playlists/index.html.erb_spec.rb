# frozen_string_literal: true

require "rails_helper"

RSpec.describe "playlists/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_playlist, :with_published_post)
    end

    @playlists = assign(:playlists, Playlist.all.alpha.page(1))
  end

  it "renders a list of playlists" do
    render
  end
end