# frozen_string_literal: true

require "rails_helper"

RSpec.describe Work do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:aspects, :milestones, :playlists, :reviews, :mixtapes, :credits, :makers, :contributions, :contributors] }
    end

    it_behaves_like "an_imageable_model"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      # Must specify individual fields for STI models.
      it { is_expected.to nilify_blanks_for(:alpha,          before: :validation) }
      it { is_expected.to nilify_blanks_for(:display_makers, before: :validation) }
      it { is_expected.to nilify_blanks_for(:medium,         before: :validation) }
      it { is_expected.to nilify_blanks_for(:subtitle,       before: :validation) }
      it { is_expected.to nilify_blanks_for(:title,          before: :validation) }
    end
  end

  describe "relationships" do
    describe "#available_relatives" do
      subject { instance.available_relatives }

      let(:instance) { create(:minimal_song) }
      let!(:song) { create(:minimal_song) }
      let!(:album) { create(:minimal_album) }

      it { is_expected.to eq([
        ["Album", [album]],
        ["Song",  [song]]
      ]) }
    end

    describe "as source" do
      describe "has associations" do
        subject { build_minimal_instance }

        it { is_expected.to have_many(:target_relationships).dependent(:destroy) }

        it { is_expected.to have_many(:target_works).through(:target_relationships) }
      end

      describe "validates nested uniqueness" do
        subject { build_minimal_instance }

        let(:target) { create_minimal_instance }
        let(:other_target) { create_minimal_instance }

        before(:each) do
          subject.target_relationships_attributes = attributes
        end

        context "without dupes" do
          let(:attributes) do
            {
              "0" => attributes_for(:minimal_work_relationship, target_id: target.id),
              "1" => attributes_for(:minimal_work_relationship, target_id: other_target.id)
            }
          end

          it { is_expected.to be_valid }
        end

        context "with dupes" do
          let(:attributes) do
            {
              "0" => attributes_for(:minimal_work_relationship, target_id: target.id),
              "1" => attributes_for(:minimal_work_relationship, target_id: target.id)
            }
          end

          it "is has the correct error" do
            is_expected.to be_invalid

            is_expected.to have_error(:target_relationships, :nested_taken)
          end
        end

        context "with duplicate targets but different connections" do
          let(:attributes) do
            {
              "0" => attributes_for(:minimal_work_relationship, target_id: target.id),
              "1" => attributes_for(:minimal_work_relationship, target_id: target.id, connection: "spinoff_of")
            }
          end

          it { is_expected.to be_valid }
        end
      end

      describe "accepts nested attributes" do
        let(:target) { create(:minimal_work) }
        let(:valid_params) { { "0" => { connection: "member_of", target_id: target.id } } }
        let(:empty_params) { { "0" => { connection: "member_of", target_id: nil       } } }

        it { is_expected.to accept_nested_attributes_for(:target_relationships).allow_destroy(true) }

        describe "#prepare_target_relationships" do
          subject { instance.target_relationships }

          before(:each) { instance.prepare_target_relationships }

          describe "initial state" do
            let(:instance) { build_minimal_instance }

            it { is_expected.to have(5).items }
          end

          describe "with prior associations" do
            let(:instance) { create_minimal_instance(target_relationships_attributes: valid_params) }

            it { is_expected.to have(6).items }
          end
        end

        describe "#reject_target_relationship?" do
          subject { instance.target_relationships }

          describe "accepts if target_id is present" do
            let(:instance) { build_minimal_instance(target_relationships_attributes: valid_params) }

            it { is_expected.to have(1).item }
          end

          describe "rejects if target_id is blank" do
            let(:instance) { build_minimal_instance(target_relationships_attributes: empty_params) }

            it { is_expected.to have(0).items }
          end
        end
      end
    end

    describe "as target" do
      describe "has associations" do
        subject { build_minimal_instance }

        it { is_expected.to have_many(:source_relationships).dependent(:destroy) }

        it { is_expected.to have_many(:source_works).through(:source_relationships) }
      end

      describe "validates nested uniqueness" do
        subject { build_minimal_instance }

        let(:source) { create_minimal_instance }
        let(:other_source) { create_minimal_instance }

        before(:each) do
          subject.source_relationships_attributes = attributes
        end

        context "without dupes" do
          let(:attributes) do
            {
              "0" => attributes_for(:minimal_work_relationship, source_id: source.id),
              "1" => attributes_for(:minimal_work_relationship, source_id: other_source.id)
            }
          end

          it { is_expected.to be_valid }
        end

        context "with dupes" do
          let(:attributes) do
            {
              "0" => attributes_for(:minimal_work_relationship, source_id: source.id),
              "1" => attributes_for(:minimal_work_relationship, source_id: source.id)
            }
          end

          it "is has the correct error" do
            is_expected.to be_invalid

            is_expected.to have_error(:source_relationships, :nested_taken)
          end
        end

        context "with duplicate sources but different connections" do
          let(:attributes) do
            {
              "0" => attributes_for(:minimal_work_relationship, source_id: source.id),
              "1" => attributes_for(:minimal_work_relationship, source_id: source.id, connection: "spinoff_of")
            }
          end

          it { is_expected.to be_valid }
        end
      end

      describe "accepts nested attributes" do
        let(:source) { create(:minimal_work) }
        let(:valid_params) { { "0" => { connection: "member_of", source_id: source.id } } }
        let(:empty_params) { { "0" => { connection: "member_of", source_id: nil       } } }

        it { is_expected.to accept_nested_attributes_for(:source_relationships).allow_destroy(true) }

        describe "#prepare_source_relationships" do
          subject { instance.source_relationships }

          before(:each) { instance.prepare_source_relationships }

          describe "initial state" do
            let(:instance) { build_minimal_instance }

            it { is_expected.to have(5).items }
          end

          describe "with prior associations" do
            let(:instance) { create_minimal_instance(source_relationships_attributes: valid_params) }

            it { is_expected.to have(6).items }
          end
        end

        describe "#reject_source_relationship?" do
          subject { instance.source_relationships }

          describe "accepts if source_id is present" do
            let(:instance) { build_minimal_instance(source_relationships_attributes: valid_params) }

            it { is_expected.to have(1).item }
          end

          describe "rejects if source_id is blank" do
            let(:instance) { build_minimal_instance(source_relationships_attributes: empty_params) }

            it { is_expected.to have(0).items }
          end
        end
      end
    end
  end

  describe "class" do
    describe "self#grouped_by_medium" do
      let(:song_1) { create(:minimal_song, maker_names: ["Wilco"]) }
      let(:song_2) { create(:minimal_song, maker_names: ["Annie"]) }
      let(:tv_show) { create(:minimal_tv_show) }
      let(:podcast) { create(:minimal_podcast) }

      let(:ids) { [song_1, song_2, tv_show, podcast].map(&:id) }

      subject { described_class.where(id: ids).grouped_by_medium }

      it "groups by type and alphabetizes" do
        is_expected.to eq([
          ["Podcast", [podcast]],
          ["Song",    [song_2, song_1]],
          ["TV Show", [tv_show]]
        ])
      end
    end

    describe "self#media" do
      subject { described_class.media }

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

    describe "self#valid_media" do
      subject { described_class.valid_media }

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

    describe "self#load_descendants" do
      before(:each) { allow(File).to receive(:basename) }

      context "in test environment" do
        before(:each) { allow(Rails).to receive(:env).and_return("test".inquiry) }

        it "loads" do
          expect(File).to receive(:basename)

          described_class.load_descendants
        end
      end

      context "in development environment" do
        before(:each) { allow(Rails).to receive(:env).and_return("development".inquiry) }

        it "loads" do
          expect(File).to receive(:basename)

          described_class.load_descendants
        end
      end

      context "in production environment" do
        before(:each) { allow(Rails).to receive(:env).and_return("production".inquiry) }

        it "does not load" do
          expect(File).to_not receive(:basename)

          described_class.load_descendants
        end
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_and_belong_to_many(:aspects) }

    it { is_expected.to have_many(:milestones).dependent(:destroy) }

    it { is_expected.to have_many(:credits).dependent(:destroy) }
    it { is_expected.to have_many(:makers).through(:credits) }

    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it { is_expected.to have_many(:contributors).through(:contributions) }

    it { is_expected.to have_many(:reviews).dependent(:nullify) }

    it { is_expected.to have_many(:playlistings).dependent(:nullify) }
    it { is_expected.to have_many(:playlists).through(:playlistings) }
    it { is_expected.to have_many(:mixtapes).through(:playlists) }
  end

  describe "attributes" do
    describe "nested" do
      describe "credits" do
        it { is_expected.to accept_nested_attributes_for(:credits).allow_destroy(true) }

        describe "reject_if" do
          it "rejects credits without a creator_id" do
            instance = build_minimal_instance(credits_attributes: {
              "0" => attributes_for(:credit, creator_id: create(:minimal_creator).id),
              "1" => attributes_for(:credit, creator_id: nil)
            })

            expect { instance.save }.to change { Credit.count }.by(1)

            expect(instance.credits).to have(1).items
          end
        end

        describe "#prepare_credits" do
          subject { instance.credits }

          before(:each) { instance.prepare_credits }

          describe "new instance" do
            let(:instance) { described_class.new }

            it { is_expected.to have(3).items }
          end

          describe "saved instance" do
            let(:instance) { create(:carl_craig_and_green_velvet_unity) }

            it { is_expected.to have(5).items }
          end
        end
      end

      describe "contributions" do
        it { is_expected.to accept_nested_attributes_for(:contributions).allow_destroy(true) }

        describe "reject_if" do
          let(:role) { create(:minimal_role, medium: "Song") }

          subject do
            build(:minimal_song, contributions_attributes: {
              "0" => attributes_for(:contribution, role_id: role.id, creator_id: create(:minimal_creator).id),
              "1" => attributes_for(:contribution, role_id: role.id, creator_id: nil)
            })
          end

          specify { expect { subject.save }.to change { Contribution.count }.by(1) }

          specify { expect(subject.contributions).to have(1).items }
        end

        describe "#prepare_contributions" do
          subject { instance.contributions }

          before(:each) { instance.prepare_contributions }

          describe "new instance" do
            let(:instance) { described_class.new }

            it { is_expected.to have(10).items }
          end

          describe "saved instance" do
            let(:instance) { create(:global_communications_76_14) }

            it { is_expected.to have(12).items }
          end
        end
      end

      describe "milestones" do
        it { is_expected.to accept_nested_attributes_for(:milestones).allow_destroy(true) }

        describe "reject_if" do
          subject do
            build(:minimal_song, milestones_attributes: {
              "0" => attributes_for(:work_milestone_for_work, year: "1981"),
              "1" => attributes_for(:work_milestone_for_work, year: "")
            })
          end

          specify { expect { subject.save }.to change { Work::Milestone.count }.by(1) }

          specify { expect(subject.milestones).to have(1).items }
        end

        describe "#prepare_milestones" do
          subject { instance.milestones }

          before(:each) { instance.prepare_milestones }

          describe "new instance" do
            let(:instance) { described_class.new }

            it { is_expected.to have(5).items }

            specify { expect(subject.map(&:activity)).to eq(["released", nil, nil, nil, nil]) }
          end

          describe "saved instance" do
            let(:instance) { create(:global_communications_76_14) }

            it { is_expected.to have(6).items }
          end
        end
      end
    end

    describe "#prepare_for_editing" do
      let(:instance) { build_minimal_instance }

      subject { instance.prepare_for_editing }

      before(:each) do
        expect(instance).to receive(:prepare_credits)
        expect(instance).to receive(:prepare_contributions)
        expect(instance).to receive(:prepare_milestones)
        expect(instance).to receive(:prepare_source_relationships)
        expect(instance).to receive(:prepare_target_relationships)
      end

      it "prepares all nested associations" do
        subject
      end
    end
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:medium) }

    it { is_expected.to validate_presence_of(:title) }

    describe "credits" do
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

    describe "custom" do
      describe "#has_released_milestone" do
        subject do
          build_minimal_instance(milestones_attributes: {
            "0" => attributes_for(:work_milestone_for_work, activity: :remixed, year: "1972")
          })
        end

        before(:each) { subject.valid? }

        it { is_expected.to have_error(milestones: :blank) }
      end

      describe "validates_nested_uniqueness_of" do
        subject { build_minimal_instance }

        describe "credits" do
          before(:each) { subject.credits = [] }

          let(:creator) { create(:minimal_creator) }
          let(:other_creator) { create(:minimal_creator) }

          let(:good_attributes) do
            {
              "0" => attributes_for(:minimal_credit, creator_id: creator.id),
              "1" => attributes_for(:minimal_credit, creator_id: other_creator.id)
            }
          end

          let(:bad_attributes) do
            {
              "0" => attributes_for(:minimal_credit, creator_id: creator.id),
              "1" => attributes_for(:minimal_credit, creator_id: creator.id)
            }
          end

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
          before(:each) { subject.contributions = [] }

          subject { build(:minimal_song) }

          let(:creator) { create(:minimal_creator) }
          let(:role_1) { create(:minimal_role, medium: "Song") }
          let(:role_2) { create(:minimal_role, medium: "Song") }

          let(:good_attributes) do
            {
              "0" => attributes_for(:minimal_credit, creator_id: creator.id, role_id: role_1.id),
              "1" => attributes_for(:minimal_credit, creator_id: creator.id, role_id: role_2.id)
            }
          end

          let(:bad_attributes) do
            {
              "0" => attributes_for(:minimal_credit, creator_id: creator.id, role_id: role_1.id),
              "1" => attributes_for(:minimal_credit, creator_id: creator.id, role_id: role_1.id)
            }
          end

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

        describe "milestones" do
          before(:each) { subject.milestones = [] }

          let(:good_attributes) do
            {
              "0" => attributes_for(:work_milestone, activity: :released,   year: "1977"),
              "1" => attributes_for(:work_milestone, activity: :remastered, year: "2005")
            }
          end

          let(:bad_attributes) do
            {
              "0" => attributes_for(:work_milestone, activity: :released, year: "1977"),
              "1" => attributes_for(:work_milestone, activity: :released, year: "2005")
            }
          end

          it "accepts non-dupes" do
            subject.milestones_attributes = good_attributes

            is_expected.to be_valid
          end

          it "rejects dupes" do
            subject.milestones_attributes = bad_attributes

            is_expected.to be_invalid
            is_expected.to have_error(:milestones, :nested_taken)
          end
        end
      end
    end
  end

  describe "hooks" do
    describe "#before_save" do
      describe "#memoize_display_makers" do
        let(:instance) { build_minimal_instance }

        subject { instance.display_makers }

        before(:each) do
          allow(instance).to receive(:collect_makers).and_return("collected")

          expect(instance).to receive(:memoize_display_makers).and_call_original

          instance.save
        end

        it { is_expected.to eq("collected") }
      end
    end
  end

  describe "instance" do
    let(:instance) { build_minimal_instance }

    describe "post methods" do
      let!(:instance) { create_minimal_instance }
      let!(:review) { create(:minimal_review, work_id: instance.id) }
      let!(:playlist) { create(:minimal_playlist) }
      let!(:mixtape) { create(:minimal_mixtape, playlist_id: playlist.id) }

      before(:each) do
        # TODO let the factory handle this with transient attributes
        playlist.tracks << create(:minimal_playlist_track, work_id: instance.id)
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

    describe "#collect_makers" do
      subject { instance.send(:collect_makers) }

      context "unsaved" do
        context "no credits" do
          let(:instance) { build(:work) }

          it { is_expected.to eq(nil) }
        end

        context "one credit" do
          let(:instance) { build(:kate_bush_never_for_ever) }

          it { is_expected.to eq("Kate Bush") }
        end

        context "multiple credits" do
          let(:instance) { create(:carl_craig_and_green_velvet_unity) }

          it { is_expected.to eq("Carl Craig & Green Velvet") }
        end
      end

      context "saved" do
        context "one credit" do
          let(:instance) { create(:kate_bush_never_for_ever) }

          it { is_expected.to eq("Kate Bush") }
        end

        context "multiple credits" do
          let(:instance) { create(:carl_craig_and_green_velvet_unity) }

          it { is_expected.to eq("Carl Craig & Green Velvet") }
        end
      end
    end

    describe "all-creator methods" do
      let(:role) { create(:minimal_role, medium: "Song") }
      let(:creator_1) { create(:minimal_creator, name: "One") }
      let(:creator_2) { create(:minimal_creator, name: "Two") }
      let(:creator_3) { create(:minimal_creator, name: "Three") }

      let(:instance) do
        create(:minimal_song, credits_attributes: {
          "0" => attributes_for(:minimal_credit, creator_id: creator_1.id),
          "1" => attributes_for(:minimal_credit, creator_id: creator_2.id),
        }, contributions_attributes: {
          "0" => attributes_for(:minimal_contribution, role_id: role.id, creator_id: creator_3.id),
          "1" => attributes_for(:minimal_contribution, role_id: role.id, creator_id: creator_2.id),
        })
      end

      describe "#creator_ids" do
        subject { instance.creator_ids }

        it { is_expected.to match_array([creator_1.id, creator_2.id, creator_3.id]) }
      end

      describe "#creators" do
        subject { instance.creators }

        it { is_expected.to match_array([creator_1, creator_2, creator_3]) }
        it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
      end
    end

    describe "#sluggable_parts" do
      let(:instance) do
        create_minimal_instance(title: "Don't Give Up", subtitle: "Single Edit", maker_names: ["Kate Bush", "Peter Gabriel"])
      end

      subject { instance.sluggable_parts }

      it { is_expected.to eq(["Songs", "Kate Bush & Peter Gabriel", "Don't Give Up", "Single Edit"]) }
    end

    describe "#alpha_parts" do
      let(:instance) { create_complete_instance }

      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.display_makers, instance.title, instance.subtitle]) }
    end
  end
end
