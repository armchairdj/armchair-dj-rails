# == Schema Information
#
# Table name: playlistings
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
#  index_playlistings_on_playlist_id  (playlist_id)
#  index_playlistings_on_work_id      (work_id)
#

require "rails_helper"

RSpec.describe Playlisting do
  describe "concerns" do
    it_behaves_like "a_listable_model", :playlist do
      let(:primary) { create(:complete_playlist).playlistings.sorted }
      let(  :other) { create(:complete_playlist).playlistings.sorted }
    end

    it_behaves_like "an_eager_loadable_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:playlist, :work] }
    end

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "self#sorted" do
      let(:playlist_1) { create(:complete_playlist, :with_published_post, title: "Z" ) }
      let(:playlist_2) { create(:complete_playlist,                       title: "A" ) }

      let(:parent_ids) { [playlist_1, playlist_2].map(&:id) }
      let(     :items) { Playlisting.where(playlist_id: parent_ids) }

      let(       :ids) { items.map(&:id).shuffle }
      let(:collection) { Playlisting.where(id: ids) }

      subject { collection.sorted }

      it "sorts by playlist name and position" do
        expected = playlist_2.playlistings.map(&:id) + playlist_1.playlistings.map(&:id)
        actual   = subject.map(&:id)

        expect(actual).to eq(expected)
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:playlist) }
    it { is_expected.to belong_to(:work    ) }
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:playlist) }
    it { is_expected.to validate_presence_of(:work) }
  end

  describe "hooks" do
    # Nothing so far.
  end

  describe "instance" do
    # Nothing so far.
  end
end
