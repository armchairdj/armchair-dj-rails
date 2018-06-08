# frozen_string_literal: true

require "rails_helper"

RSpec.describe Work, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_displayable_model"

    it_behaves_like "a_parentable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    let( :song_medium) { create(:minimal_medium, name: "Song" ) }
    let(:album_medium) { create(:minimal_medium, name: "Album") }

    let!(  :culture_beat) { create(:culture_beat_mr_vain,   medium: song_medium) }
    let!(       :robyn_s) { create(:robyn_s_give_me_love,   medium: album_medium) }
    let!(:ce_ce_peniston) { create(:ce_ce_peniston_finally, medium: song_medium) }
    let!(     :la_bouche) { create(:la_bouche_be_my_lover,  medium: album_medium) }
    let!(     :black_box) { create(:black_box_strike_it_up, medium: song_medium) }

    before(:each) do
      create(:minimal_review, :published, work: robyn_s     )
      create(:minimal_review, :published, work: la_bouche   )
      create(:minimal_review, :draft,     work: culture_beat)
      create(:minimal_review, :draft,     work: black_box   )
    end

    describe "self#grouped_options" do
      subject { described_class.grouped_options }

      specify "gives an array of optgroups and options" do
        is_expected.to eq([
          ["Album", [la_bouche, robyn_s                     ]],
          ["Song",  [black_box, ce_ce_peniston, culture_beat]]
        ])
      end
    end

    describe "self#eager" do
      subject { described_class.eager }

      it { is_expected.to eager_load(:credits, :creators, :contributions, :contributors, :reviews) }
    end

    describe "self#for_admin" do
      subject { described_class.for_admin }

      it "contains everything, unsorted" do
        is_expected.to contain_exactly(robyn_s, culture_beat, ce_ce_peniston, la_bouche, black_box)
      end

      it { is_expected.to eager_load(:credits, :creators, :contributions, :contributors, :reviews) }
    end

    describe "self#for_site" do
      subject { described_class.for_site }

      it "contains only works with published reviews, alphabetically" do
        is_expected.to eq([la_bouche, robyn_s])
      end

      it { is_expected.to eager_load(:credits, :creators, :contributions, :contributors, :reviews) }
    end
  end

  context "associations" do
    it { is_expected.to have_many(:credits) }
    it { is_expected.to have_many(:contributions) }

    it { is_expected.to have_many(:creators    ).through(:credits) }
    it { is_expected.to have_many(:contributors).through(:contributions) }

    it { is_expected.to belong_to(:medium) }
    it { is_expected.to have_many(:facets).through(:medium) }
    it { is_expected.to have_many(:categories).through(:facets) }

    it { is_expected.to have_and_belong_to_many(:tags) }

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
            instance = build(:minimal_work, credits_attributes: {
              "0" => attributes_for(:credit, creator_id: create(:minimal_creator).id),
              "1" => attributes_for(:credit, creator_id: nil                 )
            })

            expect {
              instance.save
            }.to change {
              Credit.count
            }.by(1)

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
            build(:minimal_work, contributions_attributes: {
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

    it { is_expected.to validate_presence_of(:medium) }
    it { is_expected.to validate_presence_of(:title ) }

    describe "is_expected.to validate_length_of(:credits).is_at_least(1)" do
      subject { build(:minimal_work) }

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

      describe "#only_tags_with_category" do
        let(:tag_for_item) { create(:tag_for_item) }
        let(:tag_for_work) { create(:tag_for_work) }

        subject { create(:minimal_work) }

        context "valid" do
          it "allows categorized tags" do
            subject.update(tag_ids: [tag_for_work.id])

            is_expected.to_not have_error(tag_ids: :has_uncategorized_tags)
          end
        end

        context "invalid" do
          it "disallows uncategorized tags" do
            subject.update(tag_ids: [tag_for_item.id])

            is_expected.to have_error(tag_ids: :has_uncategorized_tags)
          end
        end
      end
    end
  end

  context "hooks" do
    context "before_save" do
      context "calls #define_tag_methods" do
        before(:each) do
           allow_any_instance_of(described_class).to receive(:define_tag_methods)
          expect_any_instance_of(described_class).to receive(:define_tag_methods)
        end

        specify { build_minimal_instance }
      end
    end

    context "#define_tag_methods" do
      let!( :genre) { create(:minimal_category, name: "Musical Genre") }
      let!(  :mood) { create(:minimal_category, name: "Musical Mood" ) }
      let!(:medium) do
        create(:minimal_medium, facets_attributes: {
          "0" => { category_id:  genre.id },
          "1" => { category_id:  mood.id },
        })
      end

      subject { create(:minimal_work, medium: medium).reload }

      describe "self#permitted_tag_param" do
        specify { expect(described_class.permitted_tag_param(genre)).to eq(:musical_genre_tag_ids) }
        specify { expect(described_class.permitted_tag_param(mood )).to eq(:musical_mood_tag_ids ) }
      end

      describe "#self.tag_param" do
        specify { expect(described_class.tag_param(genre)).to eq("musical_genre") }
        specify { expect(described_class.tag_param(mood )).to eq("musical_mood" ) }
      end

      specify "#permitted_tag_params" do
        expect(subject.permitted_tag_params).to eq({
          musical_genre_tag_ids: [],
          musical_mood_tag_ids:  []
        })
      end

      describe "defines" do
        context "getters" do
          it { is_expected.to respond_to(:musical_genre_tags) }
          it { is_expected.to respond_to(:musical_mood_tags ) }
        end

        context "setters" do
          it { is_expected.to respond_to(:musical_genre_tag_ids=) }
          it { is_expected.to respond_to(:musical_mood_tag_ids= ) }
        end
      end

      context "behavior" do
        let!( :trip_hop) { create(:tag, category: genre, name: "Trip-Hop" ) }
        let!(:downtempo) { create(:tag, category: genre, name: "Downtempo") }
        let!( :sinister) { create(:tag, category: mood,  name: "Sinister" ) }
        let!(:uplifting) { create(:tag, category: mood,  name: "Uplifting") }

        subject do
          create(:minimal_work, medium: medium, tag_ids: [trip_hop.id, sinister.id]).reload
        end

        context "getters" do
          describe "retrieve scoped tags" do
            specify "#tags" do
              expect(subject.tags).to match_array([sinister, trip_hop])
            end

            specify "scoped tags methods" do
              expect(subject.musical_genre_tags).to match_array([trip_hop])
              expect(subject.musical_mood_tags ).to match_array([sinister])
            end

            specify "#tags_by_category" do
              expect(subject.tags_by_category).to eq([
                [genre, [trip_hop]],
                [mood,  [sinister]]
              ])
            end
          end
        end

        context "setters" do
          describe "blanks out tags" do
            before(:each) do
              subject.musical_genre_tag_ids = []
              subject.reload
            end

            specify "#tags" do
              expect(subject.tags).to match_array([sinister])
            end

            context "scoped tag methods" do
              it { expect(subject.musical_genre_tags).to match_array([]) }
              it { expect(subject.musical_mood_tags ).to match_array([sinister]) }
            end

            specify "#tags_by_category" do
              expect(subject.tags_by_category).to eq([
                [mood, [sinister]]
              ])
            end
          end

          describe "overwrites tags for one facet" do
            before(:each) do
              subject.musical_genre_tag_ids = [downtempo.id]
              subject.reload
            end

            specify "#tags" do
              expect(subject.tags).to match_array([sinister, downtempo])
            end

            context "scoped tag methods" do
              it { expect(subject.musical_genre_tags).to match_array([downtempo]) }
              it { expect(subject.musical_mood_tags ).to match_array([sinister]) }
            end

            specify "#tags_by_category" do
              expect(subject.tags_by_category).to eq([
                [genre, [downtempo]],
                [mood,  [sinister]]
              ])
            end
          end

          describe "overwrites tags for multiple facets without overwriting all" do
            before(:each) do
              subject.musical_genre_tag_ids = [downtempo.id]
              subject.musical_mood_tag_ids  = [uplifting.id]
              subject.reload
            end

            specify "#tags" do
              expect(subject.tags).to match_array([uplifting, downtempo])
            end

            context "scoped tag methods" do
              it { expect(subject.musical_genre_tags).to match_array([downtempo]) }
              it { expect(subject.musical_mood_tags ).to match_array([uplifting]) }
            end

            specify "#tags_by_category" do
              expect(subject.tags_by_category).to eq([
                [genre, [downtempo]],
                [mood,  [uplifting]]
              ])
            end
          end

          describe "adds tags without duplication" do
            before(:each) do
              subject.musical_genre_tag_ids = [trip_hop.id, downtempo.id]
              subject.musical_mood_tag_ids  = [sinister.id, uplifting.id]
              subject.reload
            end

            specify "#tags" do
              expect(subject.tags).to match_array([sinister, uplifting, downtempo, trip_hop])
            end

            context "scoped tag methods" do
              it { expect(subject.musical_genre_tags).to match_array([downtempo, trip_hop]) }
              it { expect(subject.musical_mood_tags ).to match_array([sinister, uplifting]) }
            end

            specify "#tags_by_category" do
              expect(subject.tags_by_category).to eq([
                [genre, [downtempo, trip_hop]],
                [mood,  [sinister, uplifting]]
              ])
            end
          end

          describe "works via update" do
            before(:each) do
              subject.update(
                "musical_genre_tag_ids" => ["#{trip_hop.id}", "#{downtempo.id}"],
                "musical_mood_tag_ids" =>  ["#{sinister.id}", "#{uplifting.id}"]
              )

              subject.reload
            end

            specify "#tags" do
              expect(subject.tags).to match_array([sinister, uplifting, downtempo, trip_hop])
            end

            context "scoped tag methods" do
              it { expect(subject.musical_genre_tags).to match_array([downtempo, trip_hop]) }
              it { expect(subject.musical_mood_tags ).to match_array([sinister, uplifting]) }
            end

            specify "#tags_by_category" do
              expect(subject.tags_by_category).to eq([
                [genre, [downtempo, trip_hop]],
                [mood,  [sinister, uplifting]]
              ])
            end
          end

          describe "gets all messed up if non-scoped setter is used" do
            before(:each) do
              subject.tag_ids = [uplifting.id]
              subject.reload
            end

            specify "#tags" do
              expect(subject.tags).to match_array([uplifting])
            end

            context "scoped tag methods" do
              it { expect(subject.musical_genre_tags).to match_array([]) }
              it { expect(subject.musical_mood_tags ).to match_array([uplifting]) }
            end

            specify "#tags_by_category" do
              expect(subject.tags_by_category).to eq([
                [mood,  [uplifting]]
              ])
            end
          end
        end
      end
    end
  end

  context "instance" do
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
      let(:invalid) {  build(:work, :with_existing_medium, :with_title  ) }
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
      describe "groups works by genre, excludes unavailable parents, and alphabetizes optgroups and options" do
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

    describe "#update_viewable_for_all" do
      let(    :creator_1) { create(:minimal_creator) }
      let(    :creator_2) { create(:minimal_creator) }
      let(:contributor_1) { create(:minimal_creator) }
      let(:contributor_2) { create(:minimal_creator) }
      let(     :category) { create(:minimal_category) }
      let( :category_tag) { create(:minimal_tag, category_id: category.id) }
      let(       :medium) { create(:minimal_medium) }
      let(        :facet) { create(:facet, category_id: category.id, medium_id: medium.id) }

      let(:work) do
        create(:minimal_work, medium_id: medium.id, tag_ids: [category_tag.id],
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

      let(:review) { create(:minimal_review, :draft, :with_body, work_id: work.id) }

      it "updates viewable for descendents" do
        review.publish!

        expect(         work.reload.viewable?).to eq(true)
        expect(       medium.reload.viewable?).to eq(true)
        expect( category_tag.reload.viewable?).to eq(true)
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
        create(:minimal_work, credits_attributes: {
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
      let(:instance) do
        create(:complete_work,
          title: "Title",
          subtitle: "Subtitle",
          medium_id: create(:song_medium).id,
          credits_attributes: {
            "0" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "First").id),
            "1" => attributes_for(:credit, creator_id: create(:minimal_creator, name: "Last").id)
          } )
      end

      subject { instance.sluggable_parts }

      it { is_expected.to eq(["Songs", "First and Last", "Title", "Subtitle"]) }
    end

    describe "#alpha_parts" do
      let(:instance) { create(:complete_work) }

      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.credited_artists, instance.title, instance.subtitle]) }
    end
  end
end
