# frozen_string_literal: true

# == Schema Information
#
# Table name: playlist_tracks
#
#  id          :bigint(8)        not null, primary key
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  playlist_id :bigint(8)
#  work_id     :bigint(8)
#
# Indexes
#
#  index_playlist_tracks_on_playlist_id  (playlist_id)
#  index_playlist_tracks_on_work_id      (work_id)
#

require "rails_helper"

RSpec.describe Playlist::Track do
  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:playlist, :work] }
    end
  end

  describe ":PlaylistAssociation" do
    it { is_expected.to belong_to(:playlist).required }

    it { is_expected.to validate_presence_of(:playlist) }

    it_behaves_like "a_listable_model", :playlist, :tracks do
      let(:primary) { create(:complete_playlist).tracks.sorted }
      let(:other) { create(:complete_playlist).tracks.sorted }
    end

    describe ".sorted" do
      let(:playlist_1) { create(:complete_playlist, :with_published_post, title: "Z") }
      let(:playlist_2) { create(:complete_playlist,                       title: "A") }

      let(:items) { described_class.where(playlist_id: [playlist_1, playlist_2].map(&:id)) }
      let(:scope) { described_class.where(id: items.map(&:id).shuffle) }

      it "sorts by playlist name and position" do
        expected = playlist_2.tracks.map(&:id) + playlist_1.tracks.map(&:id)
        actual = scope.sorted.map(&:id)

        expect(actual).to eq(expected)
      end
    end
  end

  describe ":WorkAssociation" do
    it { is_expected.to belong_to(:work).required }

    it { is_expected.to validate_presence_of(:work) }
  end
end
