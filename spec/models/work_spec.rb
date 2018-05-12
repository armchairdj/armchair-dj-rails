# frozen_string_literal: true

require "rails_helper"

RSpec.describe Work, type: :model do
  context "constants" do
    it { should have_constant(:MAX_CREDITS_AT_ONCE) }
    it { should have_constant(:MAX_CONTRIBUTIONS_AT_ONCE) }
  end

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_atomically_validatable_model", { title: nil } do
      subject { create(:minimal_work) }
    end

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    describe "self#admin_scopes" do
      specify "keys are short tab names" do
        expect(described_class.admin_scopes.keys).to eq([
          "All",
          "Viewable",
          "Non-Viewable",
        ])
      end
    end

    describe "self#default_admin_scope" do
      specify { expect(described_class.default_admin_scope).to eq(:for_admin) }
    end
  end

  context "scope-related" do
    let( :song_medium) { create(:medium, name: "Song" ) }
    let(:album_medium) { create(:medium, name: "Album") }

    let!(  :culture_beat) { create(:culture_beat_mr_vain,   medium: song_medium) }
    let!(       :robyn_s) { create(:robyn_s_give_me_love,   medium: album_medium) }
    let!(:ce_ce_peniston) { create(:ce_ce_peniston_finally, medium: song_medium) }
    let!(     :la_bouche) { create(:la_bouche_be_my_lover,  medium: album_medium) }
    let!(     :black_box) { create(:black_box_strike_it_up, medium: song_medium) }

    before(:each) do
      create(:review, :published, work: robyn_s     )
      create(:review, :published, work: la_bouche   )
      create(:review, :draft,     work: culture_beat)
      create(:review, :draft,     work: black_box   )
    end

    describe "self#grouped_options" do
      subject { described_class.grouped_options }

      specify "gives an array of optgroups and options" do
        should eq([
          ["Album", [la_bouche, robyn_s                     ]],
          ["Song",  [black_box, ce_ce_peniston, culture_beat]]
        ])
      end
    end

    describe "self#eager" do
      subject { described_class.eager }

      it { should eager_load(:credits, :creators, :contributions, :contributors, :posts) }
    end

    describe "self#for_admin" do
      subject { described_class.for_admin }

      it "contains everything, unsorted" do
        should contain_exactly(robyn_s, culture_beat, ce_ce_peniston, la_bouche, black_box)
      end

      it { should eager_load(:credits, :creators, :contributions, :contributors, :posts) }
    end

    describe "self#for_site" do
      subject { described_class.for_site }

      it "contains only works with published posts, alphabetically" do
        should eq([la_bouche, robyn_s])
      end

      it { should eager_load(:credits, :creators, :contributions, :contributors, :posts) }
    end
  end

  context "associations" do
    it { should have_many(:credits) }
    it { should have_many(:creators).through(:credits) }

    it { should have_many(:contributions) }
    it { should have_many(:contributors).through(:contributions) }

    it { should have_many(:posts) }
  end

  context "attributes" do
    context "nested" do
      context "credits" do
        it { should accept_nested_attributes_for(:credits) }

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
        it { should accept_nested_attributes_for(:contributions) }

        describe "reject_if" do
          it "rejects contributions without a creator_id" do
            instance = build(:minimal_work, contributions_attributes: {
              "0" => attributes_for(:contribution, :with_role, creator_id: create(:minimal_creator).id),
              "1" => attributes_for(:contribution, :with_role, creator_id: nil                 )
            })

            expect {
              instance.save
            }.to change {
              Contribution.count
            }.by(1)

            expect(instance.contributions).to have(1).items
          end
        end

        describe "#prepare_contributions" do
          it "prepares max for new" do
            instance = described_class.new

            expect(instance.contributions).to have(0).items

            instance.prepare_contributions

            expect(instance.contributions).to have(10).items
          end

          it "prepares up to max for saved" do
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

    it { should validate_presence_of(:medium) }
    it { should validate_presence_of(:title ) }

    context "custom" do
      describe "#at_least_one_credit" do
        subject { build(:minimal_work) }

        before(:each) do
           allow(subject).to receive(:at_least_one_credit).and_call_original
          expect(subject).to receive(:at_least_one_credit)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.credits = []

          expect(subject).to_not be_valid

          expect(subject).to have_errors(credits: :missing)
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
        expect(subject.permitted_tag_params).to eq([
          { :musical_genre_tag_ids => [] },
          { :musical_mood_tag_ids  => [] }
        ])
      end

      describe "defines" do
        context "getters" do
          it { should respond_to(:musical_genre_tags) }
          it { should respond_to(:musical_mood_tags ) }
        end

        context "setters" do
          it { should respond_to(:musical_genre_tag_ids=) }
          it { should respond_to(:musical_mood_tag_ids= ) }
        end
      end

      describe "#tags_by_category" do
        it "groups into 2D array" do
          expect(subject.tags_by_category).to eq([])
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

    describe "#display_creators" do
      let(:invalid) {  build(:work, :with_medium, :with_title  ) }
      let(:unsaved) {  build(:kate_bush_hounds_of_love         ) }
      let(  :saved) { create(:kate_bush_hounds_of_love         ) }
      let(  :multi) { create(:carl_craig_and_green_velvet_unity) }

      it "nils without error on missing creator" do
        expect(invalid.display_creators).to eq(nil)
      end

      it "gives single creator on unsaved" do
        expect(unsaved.display_creators).to eq("Kate Bush")
      end

      it "gives single creator on saved" do
        expect(saved.display_creators).to eq("Kate Bush")
      end

      it "gives mutiple creators alphabetically" do
        expect(multi.display_creators).to eq("Carl Craig & Green Velvet")
      end

      it "overrides connector" do
        expect(multi.display_creators(connector: " x ")).to eq(
          "Carl Craig x Green Velvet"
        )
      end
    end

    pending "#alpha_parts"
  end
end
