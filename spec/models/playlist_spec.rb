# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint(8)
#
# Indexes
#
#  index_playlists_on_alpha  (alpha)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#

require "rails_helper"

RSpec.describe Playlist do
  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe ":TracksAssociation" do
    it { is_expected.to have_many(:tracks).dependent(:destroy) }
    it { is_expected.to have_many(:unordered_tracks).dependent(:destroy) }
    it { is_expected.to have_many(:works).through(:unordered_tracks) }

    describe "ordering" do
      subject(:positions) { instance.tracks.map(&:position) }

      let(:instance) { create_minimal_instance }

      it { is_expected.to eq((1..2).to_a) }
    end

    describe "validation" do
      it "validate_length_of(:tracks).is_at_least(2)" do
        instance = create_minimal_instance

        expect(instance).to be_valid

        instance.tracks.first.destroy
        instance.reload

        expect(instance).to_not be_valid

        expect(instance).to have_error(tracks: :too_short)
      end
    end

    describe "nested_attributes" do
      it { is_expected.to accept_nested_attributes_for(:tracks).allow_destroy(true) }

      it "rejects tracks with blank work_id" do
        instance = build(:minimal_playlist, tracks_attributes: {
          "0" => attributes_for(:minimal_playlist_track, work_id: create(:minimal_song).id),
          "1" => attributes_for(:minimal_playlist_track, work_id: create(:minimal_song).id),
          "2" => attributes_for(:minimal_playlist_track, work_id: nil)
        })

        instance.save!

        expect(instance.tracks.length).to eq(2)
      end
    end

    describe "#prepare_tracks" do
      subject(:call_method) { instance.prepare_tracks }

      describe "new instance" do
        let(:instance) { described_class.new }

        it "builds 20 tracks" do
          expect { call_method }.to change { instance.tracks.length }.from(0).to(20)
        end
      end

      describe "saved instance with saved tracks" do
        let(:instance) { create(:minimal_playlist) }

        it "builds 20 more tracks" do
          expect { call_method }.to change { instance.tracks.length }.from(2).to(22)
        end
      end
    end
  end

  describe ":Alphabetization" do
    it_behaves_like "an_alphabetizable_model"

    describe "#alpha_parts" do
      subject(:alpha_parts) { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.title]) }
    end
  end

  describe ":AuthorAssociation" do
    it_behaves_like "an_authorable_model"
  end

  describe ":CreatorAssociations" do
    it { is_expected.to have_many(:creators).through(:works) }
    it { is_expected.to have_many(:makers).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [:author] }
      let(:show_loads) { [:author, :tracks, :works] }
    end
  end

  describe ":ImageAttachment" do
    it_behaves_like "an_imageable_model"
  end

  describe ":PostAssociations" do
    it { is_expected.to have_many(:mixtapes).dependent(:nullify) }
    it { is_expected.to have_many(:reviews).through(:works) }

    describe "association methods" do
      let!(:work) { create(:minimal_work) }
      let!(:instance) { create_minimal_instance }
      let!(:review) { create(:minimal_review, work_id: work.id) }
      let!(:mixtape) { create(:minimal_mixtape, playlist_id: instance.id) }

      let(:expected) { [review, mixtape] }

      before do
        # TODO: let the factory handle this with transient attributes
        instance.tracks << create(:minimal_playlist_track, work_id: work.id)
      end

      describe "post_ids" do
        subject(:post_ids) { instance.post_ids }

        it { is_expected.to match_array(expected.map(&:id)) }
      end

      describe "posts" do
        subject(:posts) { instance.posts }

        it { is_expected.to match_array(expected) }
      end
    end
  end

  describe ":TitleAttribute" do
    it { is_expected.to validate_presence_of(:title) }
  end
end
