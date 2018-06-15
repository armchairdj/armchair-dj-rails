# frozen_string_literal: true

require "rails_helper"

RSpec.describe Review, type: :model do
  context "concerns" do
    specify { expect(described_class.superclass).to eq(Post) }
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    let!(      :draft) { create_minimal_instance(:draft    ) }
    let!(  :scheduled) { create_minimal_instance(:scheduled) }
    let!(  :published) { create_minimal_instance(:published) }
    let!(        :ids) { [draft, scheduled, published].map(&:id) }
    let!( :collection) { described_class.where(id: ids) }
    let!(:eager_loads) { [:author, :tags, :work, :creators] }

    context "basics" do
      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to contain_exactly(*collection.to_a) }
        it { is_expected.to eager_load(eager_loads) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin }

        it { is_expected.to contain_exactly(*collection.to_a) }
        it { is_expected.to eager_load(eager_loads) }
      end

      describe "self#for_site" do
        subject { collection.for_site }

        it { is_expected.to eq [published] }
        it { is_expected.to eager_load(eager_loads) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:work) }

    it { is_expected.to have_many(:creators    ).through(:work) }
    it { is_expected.to have_many(:contributors).through(:work) }
    it { is_expected.to have_many(:aspects     ).through(:work) }
  end

  context "attributes" do
    # Nothing so far.
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:work) }
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#display_type" do
      let(:instance) { create(:never_for_ever_album_review) }
      let( :unsaved) { Review.new }

      specify { expect(instance.display_type              ).to eq("Album Review" ) }
      specify { expect(instance.display_type(plural: true)).to eq("Album Reviews") }
      specify { expect(unsaved.display_type               ).to eq("Review") }
      specify { expect(unsaved.display_type(plural: true )).to eq("Reviews") }
    end

    describe "#sluggable_parts" do
      let(:review) { create(:never_for_ever_album_review) }
      let(:collab) { create(:unity_album_review         ) }

      specify "for review" do
        expect(review.sluggable_parts) .to eq(["Kate Bush", "Never for Ever", nil])
      end

      specify "for review of work with subtitle" do
        review.work.subtitle = "Remastered"

        expect(review.sluggable_parts) .to eq(["Kate Bush", "Never for Ever", "Remastered"])
      end

      specify "for review of collaborative work" do
        expect(collab.sluggable_parts).to eq(["Carl Craig and Green Velvet", "Unity", nil])
      end
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq(instance.work.alpha_parts) }
    end
  end
end
