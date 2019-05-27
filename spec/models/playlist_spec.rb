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
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [:author] }
      let(:show_loads) { [:author, :tracks, :works] }
    end

    it_behaves_like "an_imageable_model"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "associations" do
    describe "tracks" do
      it { is_expected.to have_many(:tracks).dependent(:destroy) }

      describe "ordering" do
        let(:instance) { create_minimal_instance }

        subject { instance.tracks.map(&:position) }

        it { is_expected.to eq((1..2).to_a) }
      end
    end

    it { is_expected.to have_many(:works).through(:tracks) }

    it { is_expected.to have_many(:makers).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }

    it { is_expected.to have_many(:mixtapes).dependent(:nullify) }
  end

  describe "attributes" do
    describe "nested" do
      describe "tracks" do
        it { is_expected.to accept_nested_attributes_for(:tracks).allow_destroy(true) }

        describe "rejects" do
          let(:instance) do
            create(:minimal_playlist, tracks_attributes: {
              "0" => attributes_for(:minimal_playlist_track, work_id: create(:minimal_song).id),
              "1" => attributes_for(:minimal_playlist_track, work_id: create(:minimal_song).id),
              "2" => attributes_for(:minimal_playlist_track, work_id: nil)
            })
          end

          it "rejects blank work_id" do
            instance.save!

            expect(instance.tracks.length).to eq(2)
          end
        end

        describe "#prepare_tracks" do
          subject { instance.prepare_tracks }

          describe "new instance" do
            let(:instance) { described_class.new }

            it "builds 20 tracks" do
              expect { subject }.to change { instance.tracks.length }.from(0).to(20)
            end
          end

          describe "saved instance with saved tracks" do
            let(:instance) { create(:minimal_playlist) }

            it "builds 20 more tracks" do
              expect { subject }.to change { instance.tracks.length }.from(2).to(22)
            end
          end
        end
      end
    end
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:title) }

    describe "is_expected.to validate_length_of(:tracks).is_at_least(2)" do
      subject { create_minimal_instance }

      it { is_expected.to be_valid }

      specify "invalid" do
        subject.tracks.first.destroy
        subject.reload

        is_expected.to_not be_valid

        is_expected.to have_error(tracks: :too_short)
      end
    end
  end

  describe "instance" do
    let(:instance) { build_minimal_instance }

    describe "post methods" do
      let!(:work) { create(:minimal_work) }
      let!(:instance) { create_minimal_instance }
      let!(:review) { create(:minimal_review, work_id: work.id) }
      let!(:mixtape) { create(:minimal_mixtape, playlist_id: instance.id) }

      before(:each) do
        # TODO: let the factory handle this with transient attributes
        instance.tracks << create(:minimal_playlist_track, work_id: work.id)
      end

      describe "post_ids" do
        subject { instance.post_ids }

        it { is_expected.to contain_exactly(review.id, mixtape.id) }
      end

      describe "posts" do
        subject { instance.posts }

        it { is_expected.to contain_exactly(review, mixtape) }
      end
    end

    describe "creator methods" do
      let(:role) { create(:minimal_role, medium: "Song") }
      let(:creator_1) { create(:minimal_creator, name: "One") }
      let(:creator_2) { create(:minimal_creator, name: "Two") }
      let(:creator_3) { create(:minimal_creator, name: "Three") }
      let(:creator_4) { create(:minimal_creator, name: "Four") }

      let(:track_1) do
        create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator_2.id)
        }, contributions_attributes: {
          "0" => attributes_for(:minimal_contribution, role_id: role.id, creator_id: creator_3.id),
          "1" => attributes_for(:minimal_contribution, role_id: role.id, creator_id: creator_2.id)
        })
      end

      let(:track_2) do
        create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_4.id)
        })
      end

      let(:instance) do
        create(:minimal_playlist, tracks_attributes: {
          "0" => attributes_for(:minimal_playlist_track, work_id: track_1.id),
          "1" => attributes_for(:minimal_playlist_track, work_id: track_2.id)
        })
      end

      describe "#creator_ids" do
        subject { instance.creator_ids }

        it { is_expected.to match_array([creator_1.id, creator_2.id, creator_3.id, creator_4.id]) }
      end

      describe "#creators" do
        subject { instance.creators }

        it { is_expected.to match_array([creator_1, creator_2, creator_3, creator_4]) }
        it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
      end
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.title]) }
    end
  end
end
