# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_work" do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_displayable_model"

    it_behaves_like "a_parentable_model"

    it_behaves_like "a_linkable_model"

    it_behaves_like "a_sluggable_model"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    pending "self#grouped_options" do
    end

    describe "self#eager" do
      subject { described_class.eager }

      it { is_expected.to eager_load(:aspects, :credits, :creators, :contributions, :contributors, :reviews) }
    end

    describe "self#for_admin" do
      subject { described_class.for_admin }

      it "contains everything, unsorted" do
        is_expected.to contain_exactly(robyn_s, culture_beat, ce_ce_peniston, la_bouche, black_box)
      end

      it { is_expected.to eager_load(:aspects, :credits, :creators, :contributions, :contributors, :reviews) }
    end

    describe "self#for_site" do
      subject { described_class.for_site }

      it "contains only works with published reviews, alphabetically" do
        is_expected.to eq([la_bouche, robyn_s])
      end

      it { is_expected.to eager_load(:aspects, :credits, :creators, :contributions, :contributors, :reviews) }
    end
  end

  context "associations" do
    it { is_expected.to have_many(:milestones) }

    it { is_expected.to have_and_belong_to_many(:aspects) }

    it { is_expected.to have_many(:credits) }
    it { is_expected.to have_many(:contributions) }

    it { is_expected.to have_many(:creators    ).through(:credits) }
    it { is_expected.to have_many(:contributors).through(:contributions) }

    it { is_expected.to have_many(:reviews) }

    it { is_expected.to have_many(:playlistings) }
    it { is_expected.to have_many(:playlists).through(:playlistings) }
    it { is_expected.to have_many(:mixtapes ).through(:playlists) }
  end

  context "attributes" do
    context "nested" do
      context "credits" do
        it { is_expected.to accept_nested_attributes_for(:credits).allow_destroy(true) }

        describe "reject_if" do
          it "rejects credits without a creator_id" do
            instance = build_minimal_instance(credits_attributes: {
              "0" => attributes_for(:credit, creator_id: create(:minimal_creator).id),
              "1" => attributes_for(:credit, creator_id: nil                        )
            })

            expect { instance.save }.to change { Credit.count }.by(1)

            expect(instance.credits).to have(1).items
          end
        end

        describe "#prepare_credits" do
          context "new" do
            subject { described_class.new }

            it "builds 3" do
              expect(subject.credits).to have(0).items

              subject.prepare_credits

              expect(subject.credits).to have(3).items
            end
          end

          context "saved" do
            subject { create(:carl_craig_and_green_velvet_unity) }

            it "builds 3 more" do
              expect(subject.credits).to have(2).items

              subject.prepare_credits

              expect(subject.credits).to have(5).items
            end
          end
        end
      end

      context "contributions" do
        it { is_expected.to accept_nested_attributes_for(:contributions).allow_destroy(true) }

        describe "reject_if" do
          subject do
            build(:minimal_song, contributions_attributes: {
              "0" => attributes_for(:contribution, :with_role, creator_id: create(:minimal_creator).id),
              "1" => attributes_for(:contribution, :with_role, creator_id: nil                        )
            })
          end

          specify { expect { subject.save }.to change { Contribution.count }.by(1) }

          specify { expect(subject.contributions).to have(1).items }
        end

        describe "#prepare_contributions" do
          it "new instance" do
            instance = described_class.new

            expect(instance.contributions).to have(0).items

            instance.prepare_contributions

            expect(instance.contributions).to have(10).items
          end

          it "saved instance" do
            instance = create(:global_communications_76_14)

            expect(instance.contributions).to have(2).items

            instance.prepare_contributions

            expect(instance.contributions).to have(12).items
          end
        end
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:title ) }

    describe "is_expected.to validate_length_of(:credits).is_at_least(1)" do
      subject { build(:minimal_song) }

      specify "valid" do
        is_expected.to be_valid
      end

      specify "invalid" do
        subject.credits = []

        is_expected.to_not be_valid

        is_expected.to have_error(credits: :too_short)
      end
    end

    context "custom" do
      context "validate_nested_uniqueness_of" do
        subject { build_minimal_instance }

        describe "credits" do
          let(      :creator) { create(:minimal_creator) }
          let(:other_creator) { create(:minimal_creator) }

          let(:good_attributes) { {
            "0" => attributes_for(:minimal_credit, creator_id:       creator.id),
            "1" => attributes_for(:minimal_credit, creator_id: other_creator.id)
          }}

          let(:bad_attributes) { {
            "0" => attributes_for(:minimal_credit, creator_id: creator.id),
            "1" => attributes_for(:minimal_credit, creator_id: creator.id)
          }}

          it "accepts non-dupes" do
            subject.credits_attributes = good_attributes

            is_expected.to be_valid
          end

          it "rejects dupes" do
            subject.credits_attributes = bad_attributes

            is_expected.to be_invalid

            is_expected.to have_error(:credits, :nested_taken)
          end
        end

        describe "contributions" do
          let(   :creator) { create(:minimal_creator) }
          let( :dupe_role) { create(:minimal_role, medium_id: subject.medium.id) }
          let(:other_role) { create(:minimal_role, medium_id: subject.medium.id) }

          let(:good_attributes) { {
            "0" => attributes_for(:minimal_credit, creator_id: creator.id, role_id:  dupe_role.id),
            "1" => attributes_for(:minimal_credit, creator_id: creator.id, role_id: other_role.id)
          }}

          let(:bad_attributes) { {
            "0" => attributes_for(:minimal_credit, creator_id: creator.id, role_id: dupe_role.id),
            "1" => attributes_for(:minimal_credit, creator_id: creator.id, role_id: dupe_role.id)
          }}

          it "accepts non-dupes" do
            subject.contributions_attributes = good_attributes

            is_expected.to be_valid
          end

          it "rejects dupes" do
            subject.contributions_attributes = bad_attributes

            is_expected.to be_invalid

            is_expected.to have_error(:contributions, :nested_taken)
          end
        end
      end
    end
  end

  context "hooks" do
    # Nothing so far.
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#display_title" do
      it "displays with just title" do
        expect(create(:kate_bush_hounds_of_love).display_title).to eq(
          "Hounds of Love"
        )
      end

      it "displays with just subtitle" do
        expect(create(:junior_boys_like_a_child_c2_remix).display_title).to eq(
          "Like a Child: C2 Remix"
        )
      end

      it "nils unless persisted" do
        expect(build(:kate_bush_hounds_of_love).display_title).to eq(nil)
      end
    end

    describe "#full_display_title" do
      it "displays with one creator" do
        expect(create(:kate_bush_hounds_of_love).full_display_title).to eq(
          "Kate Bush: Hounds of Love"
        )
      end

      it "displays with multiple creators" do
        expect(create(:carl_craig_and_green_velvet_unity).full_display_title).to eq(
          "Carl Craig & Green Velvet: Unity"
        )
      end

      it "nils unless persisted" do
        expect(build(:kate_bush_hounds_of_love).full_display_title).to eq(nil)
      end
    end

    describe "#credited_artists" do
      let(:invalid) {  build(:work, :with_title                ) }
      let(:unsaved) {  build(:kate_bush_hounds_of_love         ) }
      let(  :saved) { create(:kate_bush_hounds_of_love         ) }
      let(  :multi) { create(:carl_craig_and_green_velvet_unity) }

      it "nils without error on missing creator" do
        expect(invalid.credited_artists).to eq(nil)
      end

      it "gives single creator on unsaved" do
        expect(unsaved.credited_artists).to eq("Kate Bush")
      end

      it "gives single creator on saved" do
        expect(saved.credited_artists).to eq("Kate Bush")
      end

      it "gives mutiple creators alphabetically" do
        expect(multi.credited_artists).to eq("Carl Craig & Green Velvet")
      end

      it "overrides connector" do
        expect(multi.credited_artists(connector: " x ")).to eq(
          "Carl Craig x Green Velvet"
        )
      end
    end

    describe "#grouped_parent_dropdown_options" do
      describe "groups works by type, excludes unavailable parents, and alphabetizes optgroups and options" do
        let(:creator) { create(:minimal_creator) }

        let!(:grandparent_medium) { create(:minimal_medium, name: "Grandpa") }
        let!(     :parent_medium) { create(:minimal_medium, name: "Dad"    ) }
        let!(      :child_medium) { create(:minimal_medium, name: "Son"    ) }

        let!(    :unsaved) {  build_minimal_instance(credits_attributes: { "0" => { creator_id: creator.id } }, medium: grandparent_medium                                 ) }
        let!(:grandparent) { create_minimal_instance(credits_attributes: { "0" => { creator_id: creator.id } }, medium: grandparent_medium, title: "G"                     ) }
        let!(      :uncle) { create_minimal_instance(credits_attributes: { "0" => { creator_id: creator.id } }, medium:      parent_medium, title: "U", parent: grandparent) }
        let!(     :parent) { create_minimal_instance(credits_attributes: { "0" => { creator_id: creator.id } }, medium:      parent_medium, title: "P", parent: grandparent) }
        let!(    :sibling) { create_minimal_instance(credits_attributes: { "0" => { creator_id: creator.id } }, medium:       child_medium, title: "S", parent:      parent) }
        let!(      :child) { create_minimal_instance(credits_attributes: { "0" => { creator_id: creator.id } }, medium:       child_medium, title: "C", parent:      parent) }

        specify { expect(grandparent.grouped_parent_dropdown_options).to eq([]) }

        specify { expect(unsaved.grouped_parent_dropdown_options).to eq([
          [ "Dad",     [parent, uncle ] ],
          [ "Grandpa", [grandparent   ] ],
          [ "Son",     [child, sibling] ]
        ]) }

        specify { expect(uncle.grouped_parent_dropdown_options).to eq([
          [ "Dad",      [parent        ] ],
          [ "Grandpa",  [grandparent   ] ],
          [ "Son",      [child, sibling] ]
        ]) }

        specify { expect(parent.grouped_parent_dropdown_options).to eq([
          [ "Dad",     [uncle      ] ],
          [ "Grandpa", [grandparent] ]
        ]) }

        specify { expect(sibling.grouped_parent_dropdown_options).to eq([
          [ "Dad",     [parent, uncle] ],
          [ "Grandpa", [grandparent  ] ],
          [ "Son",     [child        ] ]
        ]) }

        specify { expect(child.grouped_parent_dropdown_options).to eq([
          [ "Dad",     [parent, uncle] ],
          [ "Grandpa", [grandparent  ] ],
          [ "Son",     [sibling      ] ]
        ]) }
      end
    end

    describe "#cascade_viewable" do
      let(    :creator_1) { create(:minimal_creator) }
      let(    :creator_2) { create(:minimal_creator) }
      let(:contributor_1) { create(:minimal_creator) }
      let(:contributor_2) { create(:minimal_creator) }
      let(     :category) { create(:minimal_category) }
      let( :category_aspect) { create(:minimal_aspect, category_id: category.id) }
      let(       :medium) { create(:minimal_medium) }
      let(        :facet) { create(:facet, category_id: category.id, medium_id: medium.id) }

      let(:work) do
        create(:minimal_song, medium_id: medium.id, aspect_ids: [category_aspect.id],
          credits_attributes: {
            "0" => attributes_for(:minimal_credit, creator_id: creator_1.id),
            "1" => attributes_for(:minimal_credit, creator_id: creator_2.id),
          },
          contributions_attributes: {
            "0" => attributes_for(:minimal_contribution, creator_id: contributor_1.id),
            "1" => attributes_for(:minimal_contribution, creator_id: contributor_2.id),
          }
        )
      end

      let(:review) { create(:minimal_review, :draft, work_id: work.id) }

      it "updates viewable for descendents" do
        review.publish!

        expect(         work.reload.viewable?).to eq(true)
        expect(       medium.reload.viewable?).to eq(true)
        expect( category_aspect.reload.viewable?).to eq(true)
        expect(    creator_1.reload.viewable?).to eq(true)
        expect(    creator_1.reload.viewable?).to eq(true)
        expect(contributor_1.reload.viewable?).to eq(true)
        expect(contributor_2.reload.viewable?).to eq(true)
      end
    end

    describe "all-creator methods" do
      let(:creator_1) { create(:minimal_creator, name: "One") }
      let(:creator_2) { create(:minimal_creator, name: "Two") }
      let(:creator_3) { create(:minimal_creator, name: "Three") }

      let(:instance) do
        create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator_2.id),
        }, contributions_attributes: {
          "0" => attributes_for(:minimal_contribution, creator_id: creator_3.id),
          "1" => attributes_for(:minimal_contribution, creator_id: creator_2.id),
        })
      end

      describe "#all_creator_ids" do
        subject { instance.all_creator_ids }

        it { is_expected.to match_array([ creator_1.id, creator_2.id, creator_3.id ]) }
      end

      describe "#all_creators" do
        subject { instance.all_creators }

        it { is_expected.to match_array([ creator_1, creator_2, creator_3 ]) }
        it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
      end
    end

    describe "#sluggable_parts" do
      let(:instance) { create_complete_instance }

      subject { instance.sluggable_parts }

      it { is_expected.to eq([
        instance.model_name.human,
        instance.credited_artists(connector: " and "),
        instance.title,
        instance.subtitle
      ]) }
    end

    describe "#alpha_parts" do
      let(:instance) { create_complete_instance }

      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.credited_artists, instance.title, instance.subtitle]) }
    end
  end
end
