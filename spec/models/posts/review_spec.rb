# frozen_string_literal: true

require "rails_helper"

RSpec.describe Review do
  describe ":WorkAssociation" do
    it { is_expected.to belong_to(:work).required }
    it { is_expected.to validate_presence_of(:work) }

    it { is_expected.to have_many(:aspects).through(:work) }
    it { is_expected.to have_many(:milestones).through(:work) }

    it "delegates #display_medium to work" do
      instance = create_minimal_instance

      expect(instance.work).to receive(:display_medium).and_call_original

      instance.display_medium
    end
  end

  describe ":CreatorAssociations" do
    it { is_expected.to have_many(:creators).through(:work) }

    it { is_expected.to have_many(:makers).through(:work) }

    it { is_expected.to have_many(:contributions).through(:work) }
    it { is_expected.to have_many(:contributors).through(:work) }
  end

  describe ":CreatorFilters" do
    let(:old_album) { create(:sleater_kinney_the_hot_rock) }
    let(:new_album) { create(:sleater_kinney_the_center_wont_hold) }

    let(:band) { Creator.find_by!(name: "Sleater-Kinney") }
    let(:carrie) { Creator.find_by!(name: "Carrie Brownstein") }
    let(:annie) { Creator.find_by!(name: "St. Vincent") }

    let!(:old_review) { create_minimal_instance(work: old_album) }
    let!(:new_review) { create_minimal_instance(work: new_album) }

    specify ".by_creator finds by maker or contributor" do
      expect(described_class.by_creator(carrie)).to contain_exactly(old_review, new_review)
      expect(described_class.by_creator(annie)).to contain_exactly(new_review)
      expect(described_class.by_creator(band)).to contain_exactly(old_review, new_review)
    end

    specify ".by_maker finds only by maker, not contributor" do
      expect(described_class.by_maker(carrie.id)).to be_empty
      expect(described_class.by_maker(annie.id)).to be_empty
      expect(described_class.by_maker(band.id)).to contain_exactly(old_review, new_review)
    end

    specify ".by_contributor finds only by contributor, not maker" do
      expect(described_class.by_contributor(carrie)).to contain_exactly(old_review, new_review)
      expect(described_class.by_contributor(annie)).to contain_exactly(new_review)
      expect(described_class.by_contributor(band)).to be_empty
    end
  end

  describe ":Alphabetization" do
    it_behaves_like "an_alphabetizable_model"

    describe "#alpha_parts" do
      subject(:alpha_parts) { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq(instance.work.alpha_parts) }
    end
  end

  describe ":ImageAttachment" do
    pending "delegate hero_image to work"
    pending "delegate additional_images to work"
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [:author, :work] }
      let(:show_loads) { [:work, :makers, :contributions, :aspects, :milestones] }
    end
  end

  describe ":PublicSite" do
    describe "#related_posts" do
      let(:work) { create(:carl_craig_and_green_velvet_unity) }
      let(:carl_craig) { Creator.find_by(name: "Carl Craig") }
      let(:green_velvet) { Creator.find_by(name: "Green Velvet") }

      let(:related_works) do
        create_list(:minimal_song, 2, :with_specific_creator, specific_creator: carl_craig) +
          create_list(:minimal_song, 2, :with_specific_creator, specific_creator: green_velvet)
      end

      it "returns a reverse-cron relation of up to 3 other published articles with overlapping makers" do
        expect(described_class).to receive(:for_public).and_call_original

        review = create_minimal_instance(:published, work: work)

        related = related_works.map { |work| create_minimal_instance(:published, work: work) }

        expect(review.related_posts).to contain_exactly(related[1], related[2], related[3])
      end

      it "returns an empty relation if no other published posts with overlapping maker" do
        review = create_minimal_instance(:published, work: work)

        create_minimal_instance(:draft, work: related_works.first)

        expect(review.related_posts).to be_empty
      end
    end
  end

  describe ":SlugAttribute" do
    it_behaves_like "a_sluggable_model"

    describe "#sluggable_parts" do
      subject(:sluggable_parts) { instance.sluggable_parts }

      context "with review" do
        let(:instance) { create(:never_for_ever_album_review) }

        it { is_expected.to eq(["Albums", "Kate Bush", "Never for Ever", nil]) }
      end

      context "with review of work with subtitle" do
        let(:work) { create(:minimal_album, title: "Title", subtitle: "Subtitle", maker_names: ["Artist"]) }
        let(:instance) { create_minimal_instance(work: work) }

        it { is_expected.to eq(["Albums", "Artist", "Title", "Subtitle"]) }
      end

      context "with review of collaborative work" do
        let(:instance) { create(:unity_album_review) }

        it { is_expected.to eq(["Albums", "Carl Craig & Green Velvet", "Unity", nil]) }
      end
    end

    describe "#reset_slug_history" do
      subject(:call_method) { instance.send(:reset_slug_history) }

      let(:instance) do
        work     = create(:minimal_work, title: "foo")
        instance = create_minimal_instance(:published, work: work)

        work.update!(title: "bar")
        instance.update!(clear_slug: true)

        work.update!(title: "bat")
        instance.update!(clear_slug: true)

        instance
      end

      it "removes all old slugs so they can be reused" do
        expect { call_method }.to change(instance.slugs, :count).from(3).to(0)
      end
    end
  end

  describe ":StiInheritance" do
    specify { expect(described_class.superclass).to eq(Post) }

    describe "type" do
      subject(:instance) { described_class.new.type }

      it { is_expected.to eq("Review") }
    end

    describe "#display_type" do
      let(:instance) { create(:never_for_ever_album_review) }

      specify { expect(instance.display_type).to eq("Album Review") }
      specify { expect(instance.display_type(plural: true)).to eq("Album Reviews") }
    end
  end
end
