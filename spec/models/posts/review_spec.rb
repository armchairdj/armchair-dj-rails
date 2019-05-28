# frozen_string_literal: true

require "rails_helper"

RSpec.describe Review do
  describe "image attachments" do
    pending "delegate hero_image to work"
    pending "delegate additional_images to work"
  end

  describe "concerns" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [:author, :work] }
      let(:show_loads) { [:work, :makers, :contributions, :aspects, :milestones] }
    end
  end

  describe "STI inheritance" do
    specify { expect(described_class.superclass).to eq(Post) }

    describe "type" do
      subject { described_class.new.type }

      it { is_expected.to eq("Review") }
    end

    describe "#display_type" do
      let(:instance) { create(:never_for_ever_album_review) }

      specify { expect(instance.display_type).to eq("Album Review") }
      specify { expect(instance.display_type(plural: true)).to eq("Album Reviews") }
    end
  end

  describe "status" do
    it_behaves_like "a_model_with_a_better_enum_for", :status
  end

  describe "work" do
    it { is_expected.to belong_to(:work) }

    it { is_expected.to validate_presence_of(:work) }

    it { is_expected.to have_many(:makers).through(:work) }
    it { is_expected.to have_many(:contributions).through(:work) }
    it { is_expected.to have_many(:contributors).through(:work) }
    it { is_expected.to have_many(:aspects).through(:work) }
    it { is_expected.to have_many(:milestones).through(:work) }
  end

  describe "sluggable" do
    it_behaves_like "a_sluggable_model"

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      context "for review" do
        let(:instance) { create(:never_for_ever_album_review) }

        it { is_expected.to eq(["Albums", "Kate Bush", "Never for Ever", nil]) }
      end

      context "for review of work with subtitle" do
        let(:work) { create(:minimal_album, title: "Title", subtitle: "Subtitle", maker_names: ["Artist"]) }
        let(:instance) { create_minimal_instance(work: work) }

        it { is_expected.to eq(["Albums", "Artist", "Title", "Subtitle"]) }
      end

      context "for review of collaborative work" do
        let(:instance) { create(:unity_album_review) }

        it { is_expected.to eq(["Albums", "Carl Craig & Green Velvet", "Unity", nil]) }
      end
    end

    describe "#reset_slug_history" do
      subject { instance.send(:reset_slug_history) }

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
        expect { subject }.to change { instance.slugs.count }.from(3).to(0)
      end
    end
  end

  describe "alpha" do
    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq(instance.work.alpha_parts) }
    end
  end
end
