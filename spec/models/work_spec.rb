# frozen_string_literal: true

require "rails_helper"

RSpec.describe Work, type: :model do
  context "constants" do
    specify { expect(described_class).to have_constant(:MAX_CREDITS) }
    specify { expect(described_class).to have_constant(:MAX_CONTRIBUTIONS) }
  end

  context "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "a_summarizable_model"

    it_behaves_like "a_viewable_model"

    it_behaves_like "an_atomically_validatable_model", { title: nil, medium: nil } do
      subject { create(:minimal_work) }
    end
  end

  context "class" do
    describe "self#alphabetical_by_creator" do
      let!(:madonna_ray_of_light             ) { create(:madonna_ray_of_light             ) }
      let!(:global_communications_76_14      ) { create(:global_communications_76_14      ) }
      let!(:kate_bush_directors_cut          ) { create(:kate_bush_directors_cut          ) }
      let!(:carl_craig_and_green_velvet_unity) { create(:carl_craig_and_green_velvet_unity) }
      let!(:kate_bush_hounds_of_love         ) { create(:kate_bush_hounds_of_love         ) }

      specify { expect(described_class.alphabetical_by_creator.to_a).to eq([
        carl_craig_and_green_velvet_unity,
        global_communications_76_14,
        kate_bush_directors_cut,
        kate_bush_hounds_of_love,
        madonna_ray_of_light
      ]) }
    end

    describe "self#grouped_options" do
      specify "first element of each sub-array is an optgroup heading" do
        expect(described_class.grouped_options.to_h.keys).to eq([
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

      specify "second element of each sub-array is a list of options" do
        described_class.grouped_options.to_h.values.each do |rel|
          expect(rel).to be_a_kind_of(Array)
        end
      end

      pending "alphabetical by creator"
    end

    pending "self#media_options"

    describe "self#admin_filters" do
      specify "keys are short tab names" do
        expect(described_class.admin_filters.keys).to eq([
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
        described_class.admin_filters.values.each do |sym|
          expect(sym).to be_a_kind_of(Symbol)

          expect(described_class).to respond_to(sym)
        end
      end
    end
  end

  context "scopes" do
    describe "alphabetical" do
      let!(:tki  ) { create(:album, title: "The Kick Inside"  ) }
      let!(:lh   ) { create(:album, title: "lionheart"        ) }
      let!(:nfe  ) { create(:album, title: "Never for Ever"   ) }
      let!(:td   ) { create(:album, title: "The Dreaming"     ) }
      let!(:hol  ) { create(:album, title: "Hounds of Love"   ) }
      let!(:tsw  ) { create(:album, title: "the sensual world") }
      let!(:trs  ) { create(:album, title: "The Red Shoes"    ) }
      let!(:a    ) { create(:album, title: "aerial"           ) }
      let!(:d    ) { create(:album, title: "Director's Cut"   ) }
      let!(:fifty) { create(:album, title: "50 Words for Snow") }

      specify { expect(described_class.alphabetical.to_a).to eq([
        fifty,
        a,
        d,
        hol,
        lh,
        nfe,
        td,
        tki,
        trs,
        tsw
      ]) }
    end

    pending "eager"

    pending "for_admin"

    pending "for_site"
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

            expect(instance.credits.length).to eq(1)
          end
        end

        describe "#prepare_credits" do
          it "prepares max for new" do
            instance = described_class.new

            expect(instance.credits.length).to eq(0)

            instance.prepare_credits

            expect(instance.credits.length).to eq(5)
          end

          it "prepares up to max for saved" do
            instance = create(:carl_craig_and_green_velvet_unity)

            expect(instance.credits.length).to eq(2)

            instance.prepare_credits

            expect(instance.credits.length).to eq(5)
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

            expect(instance.contributions.length).to eq(1)
          end
        end

        describe "#prepare_contributions" do
          it "prepares max for new" do
            instance = described_class.new

            expect(instance.contributions.length).to eq(0)

            instance.prepare_contributions

            expect(instance.contributions.length).to eq(20)
          end

          it "prepares up to max for saved" do
            instance = create(:global_communications_76_14)

            expect(instance.contributions.length).to eq(2)

            instance.prepare_contributions

            expect(instance.contributions.length).to eq(20)
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
      it "displays mutiple creators alphabetically" do
        expect(create(:carl_craig_and_green_velvet_unity).display_creators).to eq(
          "Carl Craig & Green Velvet"
        )
      end

      it "displays single creator" do
        expect(create(:kate_bush_hounds_of_love).display_creators).to eq(
          "Kate Bush"
        )
      end

      it "nils unless persisted" do
        expect(build(:kate_bush_hounds_of_love).display_creators).to eq(nil)
      end
    end
  end
end
