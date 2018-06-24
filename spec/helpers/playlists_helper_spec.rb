# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistsHelper, type: :helper do
  describe "#link_to_playlist" do
    let(:instance) { create(:minimal_playlist, title: "Playlist") }

    context "default" do
      subject { helper.link_to_playlist(instance, admin: true) }

      it { is_expected.to have_tag("a[href='/admin/playlists/#{instance.to_param}']",
        text:  "Playlist",
        count: 1
      ) }
    end
  end
end
