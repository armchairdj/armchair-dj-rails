# frozen_string_literal: true

require "rails_helper"

RSpec.describe Work do
  describe ":CreatorAssociations" do
    it { is_expected.to have_many(:attributions).dependent(:destroy) }
    it { is_expected.to have_many(:credits).dependent(:destroy) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }

    it { is_expected.to have_many(:creators).through(:attributions) }
    it { is_expected.to have_many(:makers).through(:credits) }
    it { is_expected.to have_many(:contributors).through(:contributions) }

    describe "nested credits" do
      it { is_expected.to accept_nested_attributes_for(:credits).allow_destroy(true) }

      it "accepts with creator_id and rejects without" do
        instance = build_minimal_instance(credits_attributes: {
          "0" => attributes_for(:credit, creator_id: create(:minimal_creator).id),
          "1" => attributes_for(:credit, creator_id: nil)
        })

        expect { instance.save }.to change(Credit, :count).by(1)

        expect(instance.credits).to have(1).items
      end
    end

    describe "nested contributions" do
      it { is_expected.to accept_nested_attributes_for(:contributions).allow_destroy(true) }

      it "accepts with creator_id and rejects without" do
        role = create(:minimal_role, medium: "Song")

        instance = build(:minimal_song, contributions_attributes: {
          "0" => attributes_for(:contribution, role_id: role.id, creator_id: create(:minimal_creator).id),
          "1" => attributes_for(:contribution, role_id: role.id, creator_id: nil)
        })

        expect { instance.save }.to change(Contribution, :count).by(1)

        expect(instance.contributions).to have(1).items
      end
    end

    describe "nested uniqueness of credits" do
      subject(:instance) { build_minimal_instance(credits_attributes: {}) }

      let(:creator1) { create(:minimal_creator) }
      let(:creator2) { create(:minimal_creator) }

      it "accepts different creators" do
        instance.credits_attributes = {
          "0" => attributes_for(:minimal_credit, creator_id: creator1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator2.id)
        }

        is_expected.to be_valid
      end

      it "rejects duplicate creators" do
        instance.credits_attributes = {
          "0" => attributes_for(:minimal_credit, creator_id: creator1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator1.id)
        }

        is_expected.to be_invalid
        is_expected.to have_error(:credits, :nested_taken)
      end
    end

    describe "nested uniqueness of contributions" do
      subject(:instance) { build(:minimal_song, contributions_attributes: {}) }

      let(:creator1) { create(:minimal_creator) }
      let(:creator2) { create(:minimal_creator) }
      let(:role_1) { create(:minimal_role, medium: "Song") }
      let(:role_2) { create(:minimal_role, medium: "Song") }

      it "accepts same creator in non-duplicate roles" do
        instance.contributions_attributes = {
          "0" => attributes_for(:minimal_credit, creator_id: creator1.id, role_id: role_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator1.id, role_id: role_2.id)
        }

        is_expected.to be_valid
      end

      it "accepts different creators in different roles" do
        instance.contributions_attributes = {
          "0" => attributes_for(:minimal_credit, creator_id: creator1.id, role_id: role_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator2.id, role_id: role_2.id)
        }

        is_expected.to be_valid
      end

      it "accepts different creators in same role" do
        instance.contributions_attributes = {
          "0" => attributes_for(:minimal_credit, creator_id: creator1.id, role_id: role_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator2.id, role_id: role_1.id)
        }

        is_expected.to be_valid
      end

      it "rejects same creator with same role" do
        instance.contributions_attributes = {
          "0" => attributes_for(:minimal_credit, creator_id: creator1.id, role_id: role_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator1.id, role_id: role_1.id)
        }

        is_expected.to be_invalid
        is_expected.to have_error(:contributions, :nested_taken)
      end
    end

    describe "#prepare_credits" do
      it "builds 3 initially" do
        instance = described_class.new
        instance.prepare_credits

        expect(instance.credits).to have(3).items
      end

      it "builds 3 more" do
        instance = create(:global_communications_76_14)
        instance.prepare_credits

        expect(instance.credits).to have(4).items
      end
    end

    describe "#prepare_contributions" do
      it "builds 10 initially" do
        instance = described_class.new
        instance.prepare_contributions

        expect(instance.contributions).to have(10).items
      end

      it "builds 10 more" do
        instance = create(:global_communications_76_14)
        instance.prepare_contributions

        expect(instance.contributions).to have(12).items
      end
    end

    describe "credit length validation" do
      subject(:instance) { build(:minimal_song) }

      it "accepts 1 or more credits" do
        is_expected.to be_valid
      end

      it "rejects 0 credits" do
        instance.credits = []

        is_expected.to_not be_valid

        is_expected.to have_error(credits: :too_short)
      end
    end

    describe "#collect_makers" do
      subject { instance.send(:collect_makers) }

      context "with no credits" do
        let(:instance) { build(:work) }

        it { is_expected.to eq(nil) }
      end

      context "with one credit" do
        let(:instance) { build(:kate_bush_never_for_ever) }

        it { is_expected.to eq("Kate Bush") }
      end

      context "with multiple credits" do
        let(:instance) { build(:carl_craig_and_green_velvet_unity) }

        it { is_expected.to eq("Carl Craig & Green Velvet") }
      end
    end

    describe ":before_save hook to #memoize_display_makers" do
      it "denormalizes maker names as a string on work" do
        instance = build_minimal_instance

        allow(instance).to receive(:collect_makers).and_return("collected")
        expect(instance).to receive(:memoize_display_makers).and_call_original

        instance.save

        expect(instance.display_makers).to eq("collected")
      end
    end
  end

  pending ":CreatorFilters"

  describe ":AspectsAssociation" do
    it { is_expected.to have_and_belong_to_many(:aspects) }

    pending "validates #only_available_aspects"

    pending "#display_aspects"
  end

  describe ":MilestonesAssociation" do
    it { is_expected.to have_many(:milestones).dependent(:destroy) }

    it "validates #presence_of_released_milestone" do
      instance = build_minimal_instance(milestones_attributes: {
        "0" => attributes_for(:work_milestone_for_work, activity: :remixed, year: "1972")
      })

      expect(instance).to be_invalid
      expect(instance).to have_error(milestones: :blank)
    end

    describe "nested attributes" do
      it { is_expected.to accept_nested_attributes_for(:milestones).allow_destroy(true) }

      it "accepts with year and rejects without" do
        instance = build(:minimal_song, milestones_attributes: {
          "0" => attributes_for(:work_milestone_for_work, year: "1981"),
          "1" => attributes_for(:work_milestone_for_work, year: "")
        })

        expect { instance.save }.to change(Work::Milestone, :count).by(1)

        expect(instance.milestones).to have(1).items
      end
    end

    describe "nested uniqueness" do
      subject(:instance) { build(:minimal_song, milestones_attributes: {}) }

      it "accepts discrete activities" do
        instance.milestones_attributes = {
          "0" => attributes_for(:work_milestone, activity: :released,   year: "1977"),
          "1" => attributes_for(:work_milestone, activity: :remastered, year: "2005")
        }

        is_expected.to be_valid
      end

      it "rejects duplicate activities" do
        instance.milestones_attributes = {
          "0" => attributes_for(:work_milestone, activity: :released, year: "1977"),
          "1" => attributes_for(:work_milestone, activity: :released, year: "2005")
        }

        is_expected.to be_invalid
        is_expected.to have_error(:milestones, :nested_taken)
      end
    end

    describe "#prepare_milestones" do
      it "builds 5 initially and sets first to 'released' activity" do
        instance = described_class.new

        instance.prepare_milestones

        expect(instance.milestones).to have(5).items

        activities = instance.milestones.map(&:activity)

        expect(activities).to eq(["released", nil, nil, nil, nil])
      end

      it "builds 5 more" do
        instance = create(:global_communications_76_14)

        instance.prepare_milestones

        expect(instance.milestones).to have(6).items
      end
    end
  end

  describe ":RelationshipAssociations" do
    it { is_expected.to have_many(:source_relationships).dependent(:destroy) }
    it { is_expected.to have_many(:target_relationships).dependent(:destroy) }

    it { is_expected.to have_many(:source_works).through(:source_relationships) }
    it { is_expected.to have_many(:target_works).through(:target_relationships) }

    describe "nested sources" do
      it { is_expected.to accept_nested_attributes_for(:source_relationships).allow_destroy(true) }

      it "accepts with source_id" do
        instance = create_minimal_instance(source_relationships_attributes: {
          "0" => { connection: "member_of", source_id: create(:minimal_work).id }
        })

        expect(instance.source_relationships).to have(1).item
      end

      it "rejects without source_id" do
        instance = create_minimal_instance(source_relationships_attributes: {
          "0" => { connection: "member_of", source_id: nil }
        })

        expect(instance.source_relationships).to have(0).items
      end
    end

    describe "nested targets" do
      it { is_expected.to accept_nested_attributes_for(:target_relationships).allow_destroy(true) }

      it "accepts with target_id" do
        instance = create_minimal_instance(target_relationships_attributes: {
          "0" => { connection: "member_of", target_id: create(:minimal_work).id }
        })

        expect(instance.target_relationships).to have(1).item
      end

      it "rejects without target_id" do
        instance = create_minimal_instance(target_relationships_attributes: {
          "0" => { connection: "member_of", target_id: nil }
        })

        expect(instance.target_relationships).to have(0).items
      end
    end

    describe "nested uniqeness of sources" do
      let(:source1) { create_minimal_instance }
      let(:source2) { create_minimal_instance }

      it "accepts discrete sources with same connection" do
        instance = build_minimal_instance(source_relationships_attributes: {
          "0" => attributes_for(:minimal_work_relationship, source_id: source1.id),
          "1" => attributes_for(:minimal_work_relationship, source_id: source2.id)
        })

        expect(instance).to be_valid
      end

      it "accepts duplicate sources with different connections" do
        instance = build_minimal_instance(source_relationships_attributes: {
          "0" => attributes_for(:minimal_work_relationship, source_id: source1.id),
          "1" => attributes_for(:minimal_work_relationship, source_id: source1.id, connection: "spinoff_of")
        })

        expect(instance).to be_valid
      end

      it "rejects duplicate sources with same connection" do
        instance = build_minimal_instance(source_relationships_attributes: {
          "0" => attributes_for(:minimal_work_relationship, source_id: source1.id),
          "1" => attributes_for(:minimal_work_relationship, source_id: source1.id)
        })

        expect(instance).to be_invalid
        expect(instance).to have_error(:source_relationships, :nested_taken)
      end
    end

    describe "nested uniqeness of targets" do
      let(:target1) { create_minimal_instance }
      let(:target2) { create_minimal_instance }

      it "accepts discrete targets with same connection" do
        instance = build_minimal_instance(target_relationships_attributes: {
          "0" => attributes_for(:minimal_work_relationship, target_id: target1.id),
          "1" => attributes_for(:minimal_work_relationship, target_id: target2.id)
        })

        expect(instance).to be_valid
      end

      it "accepts duplicate targets with different connections" do
        instance = build_minimal_instance(target_relationships_attributes: {
          "0" => attributes_for(:minimal_work_relationship, target_id: target1.id),
          "1" => attributes_for(:minimal_work_relationship, target_id: target1.id, connection: "spinoff_of")
        })

        expect(instance).to be_valid
      end

      it "rejects duplicate targets with same connection" do
        instance = build_minimal_instance(target_relationships_attributes: {
          "0" => attributes_for(:minimal_work_relationship, target_id: target1.id),
          "1" => attributes_for(:minimal_work_relationship, target_id: target1.id)
        })

        expect(instance).to be_invalid
        expect(instance).to have_error(:target_relationships, :nested_taken)
      end
    end

    describe "#prepare_source_relationships" do
      it "builds 5" do
        instance = build_minimal_instance

        instance.prepare_source_relationships

        expect(instance.source_relationships).to have(5).items
      end

      it "builds 5 more" do
        instance = create_minimal_instance(source_relationships_attributes: {
          "0" => { connection: "member_of", source_id: create(:minimal_work).id }
        })

        instance.prepare_source_relationships

        expect(instance.source_relationships).to have(6).items
      end
    end

    describe "#prepare_target_relationships" do
      it "builds 5" do
        instance = build_minimal_instance

        instance.prepare_target_relationships

        expect(instance.target_relationships).to have(5).items
      end

      it "builds 5 more" do
        instance = create_minimal_instance(target_relationships_attributes: {
          "0" => { connection: "member_of", target_id: create(:minimal_work).id }
        })

        instance.prepare_target_relationships

        expect(instance.target_relationships).to have(6).items
      end
    end
  end

  describe ":PostAssociations" do
    it { is_expected.to have_many(:reviews).dependent(:nullify) }

    it { is_expected.to have_many(:playlistings).dependent(:nullify) }
    it { is_expected.to have_many(:playlists).through(:playlistings) }
    it { is_expected.to have_many(:mixtapes).through(:playlists) }

    describe "post methods" do
      let!(:instance) { create_minimal_instance }
      let!(:review) { create(:minimal_review, work_id: instance.id) }
      let!(:playlist) { create(:minimal_playlist) }
      let!(:mixtape) { create(:minimal_mixtape, playlist_id: playlist.id) }

      before do
        # TODO: let the factory handle this with transient attributes
        playlist.tracks << create(:minimal_playlist_track, work_id: instance.id)
      end

      describe "#post_ids" do
        subject(:post_ids) { instance.post_ids }

        it { is_expected.to contain_exactly(review.id, mixtape.id) }
      end

      describe "#posts" do
        subject(:posts) { instance.posts }

        it { is_expected.to contain_exactly(review, mixtape) }
      end
    end
  end

  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject(:instance) { build_minimal_instance }

      # Must specify individual fields for STI models.
      it { is_expected.to nilify_blanks_for(:alpha,          before: :validation) }
      it { is_expected.to nilify_blanks_for(:display_makers, before: :validation) }
      it { is_expected.to nilify_blanks_for(:medium,         before: :validation) }
      it { is_expected.to nilify_blanks_for(:subtitle,       before: :validation) }
      it { is_expected.to nilify_blanks_for(:title,          before: :validation) }
    end
  end

  describe ":Alphabetization" do
    it_behaves_like "an_alphabetizable_model"

    describe "#alpha_parts" do
      subject(:alpha_parts) { instance.alpha_parts }

      let(:instance) { create_complete_instance }

      it { is_expected.to eq([instance.display_makers, instance.title, instance.subtitle]) }
    end
  end

  describe ":Editing" do
    describe "#available_relatives" do
      subject(:array_for_dropdown) { instance.available_relatives }

      let(:instance) { create(:minimal_song) }
      let!(:song) { create(:minimal_song) }
      let!(:album) { create(:minimal_album) }

      it { is_expected.to eq([["Album", [album]], ["Song", [song]]]) }
    end

    describe "#prepare_for_editing" do
      subject(:call_method) { instance.prepare_for_editing }

      let(:instance) { build_minimal_instance }

      it "prepares all nested associations" do
        expect(instance).to receive(:prepare_credits)
        expect(instance).to receive(:prepare_contributions)
        expect(instance).to receive(:prepare_milestones)
        expect(instance).to receive(:prepare_source_relationships)
        expect(instance).to receive(:prepare_target_relationships)

        call_method
      end
    end
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:aspects, :milestones, :playlists, :reviews, :mixtapes, :credits, :makers, :contributions, :contributors] }
    end
  end

  describe ":ImageAttachment" do
    it_behaves_like "an_imageable_model"
  end

  describe ":StiInheritance" do
    it { is_expected.to validate_presence_of(:medium) }

    describe ".grouped_by_medium" do
      subject(:association) { described_class.where(id: ids).grouped_by_medium }

      let(:song_1) { create(:minimal_song, maker_names: ["Wilco"]) }
      let(:song_2) { create(:minimal_song, maker_names: ["Annie"]) }
      let(:tv_show) { create(:minimal_tv_show) }
      let(:podcast) { create(:minimal_podcast) }

      let(:ids) { [song_1, song_2, tv_show, podcast].map(&:id) }

      it "groups by type and alphabetizes" do
        is_expected.to eq([
          ["Podcast", [podcast]],
          ["Song",    [song_2, song_1]],
          ["TV Show", [tv_show]]
        ])
      end
    end

    describe ".media" do
      subject(:association) { described_class.media }

      let(:expected) do
        [
          ["Album",         "Album"],
          ["App",           "App"],
          ["Book",          "Book"],
          ["Comic Book",    "ComicBook"],
          ["Gadget",        "Gadget"],
          ["Graphic Novel", "GraphicNovel"],
          ["Movie",         "Movie"],
          ["Podcast",       "Podcast"],
          ["Product",       "Product"],
          ["Publication",   "Publication"],
          ["Radio Show",    "RadioShow"],
          ["Song",          "Song"],
          ["TV Episode",    "TvEpisode"],
          ["TV Season",     "TvSeason"],
          ["TV Show",       "TvShow"],
          ["Video Game",    "VideoGame"]
        ]
      end

      it { is_expected.to eq(expected) }
    end

    describe ".valid_media" do
      subject(:association) { described_class.valid_media }

      let(:expected) do
        [
          "Album",
          "App",
          "Book",
          "ComicBook",
          "Gadget",
          "GraphicNovel",
          "Movie",
          "Podcast",
          "Product",
          "Publication",
          "RadioShow",
          "Song",
          "TvEpisode",
          "TvSeason",
          "TvShow",
          "VideoGame"
        ]
      end

      it { is_expected.to eq(expected) }
    end

    describe ".load_descendants" do
      before { allow(File).to receive(:basename) }

      context "when in test environment" do
        before { allow(Rails).to receive(:env).and_return("test".inquiry) }

        it "loads" do
          expect(File).to receive(:basename)

          described_class.load_descendants
        end
      end

      context "when in development environment" do
        before { allow(Rails).to receive(:env).and_return("development".inquiry) }

        it "loads" do
          expect(File).to receive(:basename)

          described_class.load_descendants
        end
      end

      context "when in production environment" do
        before { allow(Rails).to receive(:env).and_return("production".inquiry) }

        it "does not load" do
          expect(File).to_not receive(:basename)

          described_class.load_descendants
        end
      end
    end
  end

  describe ":TitleAttribute" do
    it { is_expected.to validate_presence_of(:title) }

    describe "#display_title" do
      it "displays with just title" do
        expect(create(:kate_bush_never_for_ever).display_title).to eq(
          "Never for Ever"
        )
      end

      it "displays with just subtitle" do
        expect(create(:junior_boys_like_a_child_c2_remix).display_title).to eq(
          "Like a Child: C2 Remix"
        )
      end

      it "nils unless persisted" do
        expect(build(:kate_bush_never_for_ever).display_title).to eq(nil)
      end
    end

    describe "#full_display_title" do
      it "displays with one creator" do
        expect(create(:kate_bush_never_for_ever).full_display_title).to eq(
          "Kate Bush: Never for Ever"
        )
      end

      it "displays with multiple makers" do
        expect(create(:carl_craig_and_green_velvet_unity).full_display_title).to eq(
          "Carl Craig & Green Velvet: Unity"
        )
      end

      it "nils unless persisted" do
        expect(build(:kate_bush_never_for_ever).full_display_title).to eq(nil)
      end
    end
  end
end
