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
  it_behaves_like "a_listable_model", :playlist, :tracks do
    let(:primary) { create(:complete_playlist).tracks.sorted }
    let(:other) { create(:complete_playlist).tracks.sorted }
  end

  it_behaves_like "a_ginsu_model" do
    let(:list_loads) { [] }
    let(:show_loads) { [:playlist, :work] }
  end

  describe "nilify_blanks" do
    subject(:instance) { build_minimal_instance }

    it { is_expected.to nilify_blanks(before: :validation) }
  end

  describe "scope-related" do
    describe ".sorted" do
      subject(:association) { collection.sorted }

      let(:playlist_1) { create(:complete_playlist, :with_published_post, title: "Z") }
      let(:playlist_2) { create(:complete_playlist,                       title: "A") }

      let(:parent_ids) { [playlist_1, playlist_2].map(&:id) }
      let(:items) { described_class.where(playlist_id: parent_ids) }

      let(:ids) { items.map(&:id).shuffle }
      let(:collection) { described_class.where(id: ids) }

      it "sorts by playlist name and position" do
        expected = playlist_2.tracks.map(&:id) + playlist_1.tracks.map(&:id)
        actual   = association.map(&:id)

        expect(actual).to eq(expected)
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:playlist).required }
    it { is_expected.to belong_to(:work).required }
  end

  describe "validations" do
    subject(:instance) { build_minimal_instance }

    it { is_expected.to validate_presence_of(:playlist) }
    it { is_expected.to validate_presence_of(:work) }
  end
end
