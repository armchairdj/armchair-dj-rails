# frozen_string_literal: true

require "rails_helper"

RSpec.describe Review, type: :model do
  describe "concerns" do
    specify { expect(described_class.superclass).to eq(Post) }
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    let!(      :draft) { create_minimal_instance(:draft    ) }
    let!(  :scheduled) { create_minimal_instance(:scheduled) }
    let!(  :published) { create_minimal_instance(:published) }
    let!(        :ids) { [draft, scheduled, published].map(&:id) }
    let!( :collection) { described_class.where(id: ids) }
    let!(:eager_loads) { [:author, :links, :tags, :work, :makers, :contributions, :aspects, :milestones] }

    describe "basics" do
      describe "self#for_show" do
        subject { collection.for_show }

        it { is_expected.to contain_exactly(*collection.to_a) }
        it { is_expected.to eager_load(eager_loads) }
      end

      pending "self#for_list"

      describe "self#for_public" do
        subject { collection.for_public }

        it { is_expected.to eq [published] }
        it { is_expected.to_not eager_load(eager_loads) }
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:work) }

    it { is_expected.to have_many(:makers       ).through(:work) }
    it { is_expected.to have_many(:contributions).through(:work) }
    it { is_expected.to have_many(:contributors ).through(:work) }
    it { is_expected.to have_many(:aspects      ).through(:work) }
    it { is_expected.to have_many(:milestones   ).through(:work) }
  end

  describe "attributes" do
    # Nothing so far.
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:work) }
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    describe "#display_type" do
      let(:instance) { create(:never_for_ever_album_review) }

      specify { expect(instance.display_type              ).to eq("Album Review" ) }
      specify { expect(instance.display_type(plural: true)).to eq("Album Reviews") }
    end

    describe "#sluggable_parts" do
      let(:review) { create(:never_for_ever_album_review) }
      let(:collab) { create(:unity_album_review         ) }

      specify "for review" do
        expect(review.sluggable_parts) .to eq(["Albums", "Kate Bush", "Never for Ever", nil])
      end

      specify "for review of work with subtitle" do
        review.work.subtitle = "Remastered"

        expect(review.sluggable_parts) .to eq(["Albums", "Kate Bush", "Never for Ever", "Remastered"])
      end

      specify "for review of collaborative work" do
        expect(collab.sluggable_parts).to eq(["Albums", "Carl Craig & Green Velvet", "Unity", nil])
      end
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq(instance.work.alpha_parts) }
    end
  end
end
