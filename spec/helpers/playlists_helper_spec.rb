# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistsHelper, type: :helper do
  describe "#link_to_playlist" do
    let(:instance) { create(:minimal_playlist, title: "Playlist") }

    context "viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(true)
      end

      context "public" do
        subject { helper.link_to_playlist(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/playlists/#{instance.slug}'][class='test']",
          text:  "Playlist",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_playlist(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/playlists/#{instance.to_param}']",
          text:  "Playlist",
          count: 1
        ) }
      end
    end

    context "non-viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_playlist(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_playlist(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/playlists/#{instance.to_param}']",
          text:  "Playlist",
          count: 1
        ) }
      end
    end
  end
end
