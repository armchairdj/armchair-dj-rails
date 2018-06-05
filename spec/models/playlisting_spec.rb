require "rails_helper"

RSpec.describe Playlisting, type: :model do
  context "concerns" do
    it_behaves_like "an_acts_as_list_model", 1, :playlist do
      let(:one) { create(:complete_playlist).playlistings }
      let(:two) { create(:complete_playlist).playlistings }
    end
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let(:playlist_1) { create(:complete_playlist, :with_published_post, title: "Z" ) }
      let(:playlist_2) { create(:complete_playlist,                       title: "A" ) }
      let(       :ids) { Playlisting.where(playlist_id: [playlist_1.id, playlist_2.id]).map(&:id).shuffle }
      let(:collection) { Playlisting.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:playlist, :work) }
      end

      describe "self#sorted" do
        subject { collection.sorted }

        it { is_expected.to_not eager_load(:playlist, :work) }

        it "sorts by playlist name and position" do
          expected = playlist_2.playlistings.map(&:id) + playlist_1.playlistings.map(&:id)
          actual   = collection.map(&:id)

          expect(actual).to eq(expected)
        end
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        specify "includes all, sorted" do
          expected = playlist_2.playlistings.map(&:id) + playlist_1.playlistings.map(&:id)
          actual   = collection.map(&:id)

          expect(actual).to eq(expected)
        end

        it { is_expected.to eager_load(:playlist, :work) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        specify "includes all, sorted" do
          expected = playlist_2.playlistings.map(&:id) + playlist_1.playlistings.map(&:id)
          actual   = collection.map(&:id)

          expect(actual).to eq(expected)
        end

        it { is_expected.to eager_load(:playlist, :work) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:playlist) }
    it { is_expected.to belong_to(:work    ) }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:playlist) }
    it { is_expected.to validate_presence_of(:work) }
  end

  context "hooks" do
    # Nothing so far.
  end

  context "instance" do
    # Nothing so far.
  end
end
