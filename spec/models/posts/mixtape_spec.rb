# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mixtape do
  describe ":PlaylistAssociations" do
    it { is_expected.to belong_to(:playlist).required }

    it { is_expected.to have_many(:tracks).through(:playlist) }

    it { is_expected.to validate_presence_of(:playlist) }
  end

  describe ":WorksAssociations" do
    it { is_expected.to have_many(:works).through(:tracks) }

    it { is_expected.to have_many(:aspects).through(:works) }

    it { is_expected.to have_many(:milestones).through(:works) }
  end

  describe ":CreatorAssociations" do
    it { is_expected.to have_many(:creators).through(:works) }
    it { is_expected.to have_many(:makers).through(:works) }
    it { is_expected.to have_many(:contributions).through(:works) }
    it { is_expected.to have_many(:contributors).through(:works) }
  end

  describe ":CreatorFilters" do
    let!(:builder1) do
      FactoryBuilders::Mixtape.new(
        maker_names:       ["Kate Bush", "TLC", "Richie Hawtin"],
        contributor_names: ["Stereolab"]
      )
    end

    let!(:builder2) do
      FactoryBuilders::Mixtape.new(
        maker_names:       ["Kate Bush", "Róisín Murphy", "Stereolab"],
        contributor_names: ["Richie Hawtin"]
      )
    end

    let!(:mixtape1) { builder1.mixtape }
    let!(:mixtape2) { builder2.mixtape }

    let!(:kate_bush) { builder1.makers["Kate Bush"] }
    let!(:richie) { builder1.makers["Richie Hawtin"] }
    let!(:tlc) { builder1.makers["TLC"] }
    let!(:stereolab) { builder2.makers["Stereolab"] }

    specify ".by_creator finds by maker or contributor" do
      expect(described_class.by_creator(kate_bush)).to contain_exactly(mixtape1, mixtape2)
      expect(described_class.by_creator(richie)).to contain_exactly(mixtape1, mixtape2)
      expect(described_class.by_creator(tlc)).to contain_exactly(mixtape1)
      expect(described_class.by_creator(stereolab)).to contain_exactly(mixtape1, mixtape2)
    end

    specify ".by_maker finds only by maker, not contributor" do
      expect(described_class.by_maker(kate_bush)).to contain_exactly(mixtape1, mixtape2)
      expect(described_class.by_maker(richie)).to contain_exactly(mixtape1)
      expect(described_class.by_maker(tlc)).to contain_exactly(mixtape1)
      expect(described_class.by_maker(stereolab)).to contain_exactly(mixtape2)
    end

    specify ".by_contributor finds only by contributor, not maker" do
      expect(described_class.by_contributor(kate_bush)).to be_empty
      expect(described_class.by_contributor(richie)).to contain_exactly(mixtape2)
      expect(described_class.by_contributor(tlc)).to be_empty
      expect(described_class.by_contributor(stereolab)).to contain_exactly(mixtape1)
    end
  end

  describe ":Alphabetization" do
    it_behaves_like "an_alphabetizable_model"

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.playlist.title]) }
    end
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [:author, :playlist] }
      let(:show_loads) { [:playlist, :tracks, :works, :makers, :contributions, :aspects, :milestones] }
    end
  end

  describe ":ImageAttachment" do
    pending "delegate hero_image to playlist"
    pending "delegate additional_images to playlist"
  end

  describe ":PublicSite" do
    describe "#related_posts" do
      let!(:builders) do
        5.times.each.with_object([]) do |(_index), memo|
          memo << FactoryBuilders::Mixtape.new(maker_names: ["Derrick May", "Carl Craig"])
        end
      end

      it "returns a reverse-cron relation of up to 3 other published mixtapes with overlapping makers" do
        # expect(described_class).to receive(:for_public).and_call_original

        mixtape, _related0, related1, related2, related3 = builders.map(&:mixtape)

        expect(mixtape.related_posts).to contain_exactly(related1, related2, related3)
      end

      it "returns an empty relation if no other published posts with overlapping maker" do
        mixtape = create_minimal_instance(:published)

        create_minimal_instance(:draft, playlist: mixtape.playlist)

        expect(mixtape.related_posts).to be_empty
      end
    end
  end

  describe ":SlugAttribute" do
    it_behaves_like "a_sluggable_model"

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.playlist.title]) }
    end

    describe "#reset_slug_history" do
      subject(:call_method) { instance.send(:reset_slug_history) }

      let(:instance) do
        playlist = create(:minimal_playlist, title: "foo")
        instance = create_minimal_instance(:published, playlist: playlist)

        playlist.update!(title: "bar")
        instance.update!(clear_slug: true)

        playlist.update!(title: "bat")
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
      subject { described_class.new.type }

      it { is_expected.to eq("Mixtape") }
    end

    describe "#display_type" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.display_type).to eq("Mixtape") }
      specify { expect(instance.display_type(plural: true)).to eq("Mixtapes") }
    end
  end
end
