# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistsHelper do
  describe "#link_to_playlist" do
    let(:instance) { create(:minimal_playlist, title: "Playlist") }

    describe "default" do
      subject { helper.link_to_playlist(instance, admin: true) }

      it "has the correct markup" do
        is_expected.to have_tag(
          "a[href='/admin/playlists/#{instance.to_param}']",
          text:  "Playlist",
          count: 1
        )
      end
    end
  end
end
