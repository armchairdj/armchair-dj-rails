require "rails_helper"

RSpec.describe Playlist, type: :model do
  context "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_displayable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let!( :first) { create(:complete_playlist, title: "First" ) }
      let!(:middle) { create(:complete_playlist, title: "Middle") }
      let!(  :last) { create(:complete_playlist, title: "Last"  ) }

      let(:ids) { [first, middle, last].map(&:id) }

      describe "self#eager" do
        subject { described_class.eager }

        it { is_expected.to eager_load(:playlistings, :works) }
      end

      describe "self#for_admin" do
        subject { described_class.for_admin.where(id: ids) }

        specify "includes all, unsorted" do
          is_expected.to match_array([first, middle, last])
        end

        it { is_expected.to eager_load(:playlistings, :works) }
      end

      describe "self#for_site" do
        subject { described_class.for_site.where(id: ids) }

        specify "includes all, sorted alphabetically" do
          is_expected.to eq([first, last, middle])
        end

        it { is_expected.to eager_load(:playlistings, :works) }
      end
    end
  end

  context "associations" do
    describe "playlistings" do
      let(:instance) { create_complete_instance }

      it { is_expected.to have_many(:playlistings) }

      describe "ordering" do
        subject { instance.playlistings.map(&:position) }

        it { is_expected.to eq((1..10).to_a) }
      end
    end

    it { is_expected.to have_many(:works).through(:playlistings) }

    it { is_expected.to have_many(:creators    ).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }

    # it { is_expected.to have_many(:mixtapes) }
  end

  context "attributes" do
    context "nested" do
      describe "playlistings" do
        it { is_expected.to accept_nested_attributes_for(:playlistings).allow_destroy(true) }

        describe "rejects" do
          let(:instance) do
            create(:minimal_playlist, playlistings_attributes: {
              "0" => attributes_for(:minimal_playlisting, work_id: create(:minimal_work).id),
              "1" => attributes_for(:minimal_playlisting, work_id: create(:minimal_work).id),
              "2" => attributes_for(:minimal_playlisting, work_id: nil),
            })
          end

          it "rejects blank work_id" do
            instance.save!

            expect(instance.playlistings.length).to eq(2)
          end
        end

        describe "#prepare_playlistings" do
          context "new instance" do
            subject { described_class.new }

            it "builds 20 playlistings" do
              expect(subject.playlistings).to have(0).items

              subject.prepare_playlistings

              expect(subject.playlistings).to have(20).items
            end
          end

          context "saved instance with saved playlistings" do
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

  context "validations" do
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

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#reorder_playlistings!" do
      let( :instance) { create_complete_instance }
      let(      :ids) { instance.playlistings.map(&:id) }
      let( :shuffled) { ids.shuffle }
      let(    :other) { create_complete_instance }
      let(:other_ids) { other.playlistings.map(&:id) }

      it "reorders" do
        instance.reorder_playlistings!(shuffled)

        actual = instance.reload.playlistings

        expect(actual.map(&:id)).to eq(shuffled)
        expect(actual.map(&:position)).to eq((1..10).to_a)
      end

      it "raises if bad ids" do
        expect {
          instance.reorder_playlistings!(other_ids)
        }.to raise_exception(ArgumentError)
      end

      it "raises if not enough ids" do
        shuffled.shift

        expect {
          instance.reorder_playlistings!(shuffled)
        }.to raise_exception(ArgumentError)
      end
    end

    describe "all-creator methods" do
      let(:creator_1) { create(:minimal_creator, name: "One") }
      let(:creator_2) { create(:minimal_creator, name: "Two") }
      let(:creator_3) { create(:minimal_creator, name: "Three") }
      let(:creator_4) { create(:minimal_creator, name: "Four") }

      let(:track_1) do
        create(:minimal_work, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator_2.id),
        }, contributions_attributes: {
          "0" => attributes_for(:minimal_contribution, creator_id: creator_3.id),
          "1" => attributes_for(:minimal_contribution, creator_id: creator_2.id),
        })
      end

      let(:track_2) do
        create(:minimal_work, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_4.id),
        })
      end

      let(:instance) do
        create(:minimal_playlist, playlistings_attributes: {
          "0" => attributes_for(:minimal_playlisting, work_id: track_1.id),
          "1" => attributes_for(:minimal_playlisting, work_id: track_2.id),
        })
      end

      describe "#all_creator_ids" do
        subject { instance.all_creator_ids }

        it { is_expected.to match_array([ creator_1.id, creator_2.id, creator_3.id, creator_4.id ]) }
      end

      describe "#all_creators" do
        subject { instance.all_creators }

        it { is_expected.to match_array([ creator_1, creator_2, creator_3, creator_4 ]) }
        it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
      end
    end

    let(     :category) { create(:category, name: "Category") }
    let(:uncategorized) { create(:tag, name: "Uncategorized") }
    let(  :categorized) { create(:tag, name: "Categorized", category_id: category.id) }

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      it { is_expected.to eq([instance.title]) }
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.title]) }
    end
  end
end
