# frozen_string_literal: true

require "rails_helper"

RSpec.describe Work, type: :model do
  context "constants" do
    specify { expect(described_class).to have_constant(:MAX_CREDITS_AT_ONCE) }
    specify { expect(described_class).to have_constant(:MAX_CONTRIBUTIONS_AT_ONCE) }
  end

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "an_atomically_validatable_model", { title: nil, medium: nil } do
      subject { create(:minimal_work) }
    end

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"
  end

  context "class" do
    describe "self#media_options" do
      subject { described_class.media_options }

      it "gives a 2D array js-enhanced dropdowns" do
        should eq([
          ["Song",         "song",       { "data-work-grouping" => 1 } ],
          ["Album",        "album",      { "data-work-grouping" => 1 } ],
          ["Movie",        "movie",      { "data-work-grouping" => 2 } ],
          ["TV Show",      "tv_show",    { "data-work-grouping" => 2 } ],
          ["Radio Show",   "radio_show", { "data-work-grouping" => 2 } ],
          ["Podcast",      "podcast",    { "data-work-grouping" => 2 } ],
          ["Book",         "book",       { "data-work-grouping" => 3 } ],
          ["Comic Book",   "comic",      { "data-work-grouping" => 3 } ],
          ["Newspaper",    "newspaper",  { "data-work-grouping" => 3 } ],
          ["Magazine",     "magazine",   { "data-work-grouping" => 3 } ],
          ["Artwork",      "artwork",    { "data-work-grouping" => 4 } ],
          ["Game",         "game",       { "data-work-grouping" => 5 } ],
          ["Software",     "software",   { "data-work-grouping" => 5 } ],
          ["Hardware",     "hardware",   { "data-work-grouping" => 5 } ],
          ["Product",      "product",    { "data-work-grouping" => 6 } ]
        ])
      end
    end

    describe "self#admin_filters" do
      subject { described_class.admin_filters }

      specify "keys are short tab names" do
        expect(subject.keys).to eq([
          "Songs",
          "Albums",
          "Movies",
          "TV Shows",
          "Radio Shows",
          "Podcasts",
          "Books",
          "Comics",
          "Newspapers",
          "Magazines",
          "Artworks",
          "Games",
          "Software",
          "Hardware",
          "Products"
        ])
      end

      specify "values are symbols of scopes" do
        subject.values.each do |sym|
          expect(sym).to be_a_kind_of(Symbol)

          expect(described_class).to respond_to(sym)
        end
      end
    end
  end

  context "scope-related" do
    let!(       :robyn_s) { create(:robyn_s_give_me_love  ) }
    let!(  :culture_beat) { create(:culture_beat_mr_vain  ) }
    let!(:ce_ce_peniston) { create(:ce_ce_peniston_finally) }
    let!(     :la_bouche) { create(:la_bouche_be_my_lover ) }
    let!(     :black_box) { create(:black_box_strike_it_up) }

    before(:each) do
      create(:song_review, :published, work: robyn_s     )
      create(:song_review, :published, work: la_bouche   )
      create(:song_review, :draft,     work: culture_beat)
      create(:song_review, :draft,     work: black_box   )
    end

    describe "self#grouped_options" do
      subject { described_class.grouped_options }

      specify "gives a grouped 2D array of works for dropdown" do
        should be_a_kind_of(Array)
      end

      specify "arranges options into optgroups" do
        expect(subject.map(&:first)).to eq([
          "Songs",
          "Albums",
          "Movies",
          "TV Shows",
          "Radio Shows",
          "Podcasts",
          "Books",
          "Comics",
          "Newspapers",
          "Magazines",
          "Artworks",
          "Games",
          "Software",
          "Hardware",
          "Products"
        ])
      end

      specify "second element of each sub-array is a relation of options" do
        subject.map(&:last).each do |rel|
          expect(rel).to be_a_kind_of(ActiveRecord::Relation)
        end
      end

      describe "sorts each set of options alphabetically" do
        subject { described_class.grouped_options.to_h["Songs"] }

        it { should eq([black_box, ce_ce_peniston, culture_beat, la_bouche, robyn_s]) }
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
            instance = build(:song, credits_attributes: {
              "0" => attributes_for(:credit, creator_id: create(:musician).id),
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
          it "prepares max for new" do
            instance = described_class.new

            expect(instance.credits).to have(0).items

            instance.prepare_credits

            expect(instance.credits).to have(3).items
          end

          it "prepares max for saved" do
            instance = create(:carl_craig_and_green_velvet_unity)

            expect(instance.credits).to have(2).items

            instance.prepare_credits

            expect(instance.credits).to have(5).items
          end
        end
      end

      context "contributions" do
        it { should accept_nested_attributes_for(:contributions) }

        describe "reject_if" do
          it "rejects contributions without a creator_id" do
            instance = build(:song, contributions_attributes: {
              "0" => attributes_for(:contribution, role: "producer", creator_id: create(:musician).id),
              "1" => attributes_for(:contribution, role: "producer", creator_id: nil                 )
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

    context "enums" do
      describe "medium" do
        it { should define_enum_for(:medium) }

        it_behaves_like "an_enumable_model", [:medium]
      end
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:medium) }
    it { should validate_presence_of(:title ) }

    context "custom" do
      describe "#at_least_one_credit" do
        subject { build(:song) }

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
      let(:invalid) {  build(:work_without_credits             ) }
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
  end
end
