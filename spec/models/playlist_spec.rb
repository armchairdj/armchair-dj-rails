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

RSpec.describe Playlist, type: :model do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      describe "nilify_blanks" do
        it { is_expected.to nilify_blanks(before: :validation) }
      end
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "basics" do
      let(       :ids) { create_list(:minimal_playlist, 3).map(&:id) }
      let(:collection) { described_class.where(id: ids) }
      let(:list_loads) { [:author] }
      let(:show_loads) { [:author, :playlistings, :works] }

      describe "self#for_show" do
        subject { collection.for_show }

        it { is_expected.to eager_load(show_loads) }
        it { is_expected.to contain_exactly(*collection.to_a) }
      end

      describe "self#for_list" do
        subject { collection.for_list }

        it { is_expected.to eager_load(list_loads) }
        it { is_expected.to contain_exactly(*collection.to_a) }
      end
    end
  end

  describe "associations" do
    describe "playlistings" do
      let(:instance) { create_complete_instance }

      it { is_expected.to have_many(:playlistings) }

      describe "ordering" do
        subject { instance.playlistings.map(&:position) }

        it { is_expected.to eq((1..10).to_a) }
      end
    end

    it { is_expected.to have_many(:works).through(:playlistings) }

    it { is_expected.to have_many(:makers      ).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }

    it { is_expected.to have_many(:mixtapes) }
  end

  describe "attributes" do
    describe "nested" do
      describe "playlistings" do
        it { is_expected.to accept_nested_attributes_for(:playlistings).allow_destroy(true) }

        describe "rejects" do
          let(:instance) do
            create(:minimal_playlist, playlistings_attributes: {
              "0" => attributes_for(:minimal_playlisting, work_id: create(:minimal_song).id),
              "1" => attributes_for(:minimal_playlisting, work_id: create(:minimal_song).id),
              "2" => attributes_for(:minimal_playlisting, work_id: nil),
            })
          end

          it "rejects blank work_id" do
            instance.save!

            expect(instance.playlistings.length).to eq(2)
          end
        end

        describe "#prepare_playlistings" do
          describe "new instance" do
            subject { described_class.new }

            it "builds 20 playlistings" do
              expect(subject.playlistings).to have(0).items

              subject.prepare_playlistings

              expect(subject.playlistings).to have(20).items
            end
          end

          describe "saved instance with saved playlistings" do
            subject { create(:minimal_playlist) }

            it "builds 20 more playlistings" do
              expect(subject.playlistings).to have(2).items

              subject.prepare_playlistings

              expect(subject.playlistings).to have(22).items
            end
          end
        end
      end
    end
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:title) }

    describe "is_expected.to validate_length_of(:playlistings).is_at_least(2)" do
      it { is_expected.to be_valid }

      specify "invalid" do
        subject.playlistings.first.destroy
        subject.reload

        is_expected.to_not be_valid

        is_expected.to have_error(playlistings: :too_short)
      end
    end
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    pending "#posts"

    describe "creator methods" do
      let(:role     ) { create(:minimal_role, medium: "Song") }
      let(:creator_1) { create(:minimal_creator, name: "One") }
      let(:creator_2) { create(:minimal_creator, name: "Two") }
      let(:creator_3) { create(:minimal_creator, name: "Three") }
      let(:creator_4) { create(:minimal_creator, name: "Four") }

      let(:track_1) do
        create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator_2.id),
        }, contributions_attributes: {
          "0" => attributes_for(:minimal_contribution, role_id: role.id, creator_id: creator_3.id),
          "1" => attributes_for(:minimal_contribution, role_id: role.id, creator_id: creator_2.id),
        })
      end

      let(:track_2) do
        create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_4.id),
        })
      end

      let(:instance) do
        create(:minimal_playlist, playlistings_attributes: {
          "0" => attributes_for(:minimal_playlisting, work_id: track_1.id),
          "1" => attributes_for(:minimal_playlisting, work_id: track_2.id),
        })
      end

      describe "#creator_ids" do
        subject { instance.creator_ids }

        it { is_expected.to match_array([ creator_1.id, creator_2.id, creator_3.id, creator_4.id ]) }
      end

      describe "#creators" do
        subject { instance.creators }

        it { is_expected.to match_array([ creator_1, creator_2, creator_3, creator_4 ]) }
        it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
      end
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.title]) }
    end
  end
end
