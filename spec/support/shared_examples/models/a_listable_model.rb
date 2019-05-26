# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_listable_model" do |scope, association_name|
  describe "configuration" do
    # :primary and :other defined by caller as scoped acts_as_list collections

    it "respects scope" do
      expect(primary.maximum(:position)).to eq(primary.length)
      expect(other.maximum(:position)).to eq(other.length)
    end

    it "respects top_of_list=1" do
      expect(primary.minimum(:position)).to eq(1)
      expect(other.minimum(:position)).to eq(1)
    end
  end

  describe "class" do
    subject { described_class }

    it { is_expected.to respond_to(:acts_as_list_no_update) }

    describe "#reorder_for!" do
      let(:parent) { primary.first.send(scope) }

      subject { described_class.reorder_for!(parent, reordered_ids) }

      describe "success" do
        let(:reordered_ids) { primary.ids.shuffle }

        it "reorders" do
          subject

          actual = parent.reload.send(association_name).sorted

          expect(actual.ids).to eq(reordered_ids)
          expect(actual.map(&:position)).to eq((1..primary.length).to_a)
        end
      end

      describe "raises if bad ids" do
        let(:reordered_ids) { other.ids.shuffle }

        specify { expect { subject }.to raise_exception(ArgumentError) }
      end

      describe "raises if repeated ids" do
        let(:reordered_ids) { primary.ids.shuffle + [primary.ids.first] }

        specify { expect { subject }.to raise_exception(ArgumentError) }
      end

      describe "raises if not enough ids" do
        let(:reordered_ids) { primary.ids.shuffle - [primary.ids.first] }

        specify { expect { subject }.to raise_exception(ArgumentError) }
      end
    end
  end

  describe "scope-related" do
    describe "#sorted" do
      describe "sorts by scoped association ID and position" do
        subject do
          primary_ids = primary.ids.shuffle
          other_ids   = other.ids.shuffle

          described_class.where(id: other_ids + primary_ids).sorted
        end

        it { is_expected.to eq(primary.sorted + other.sorted) }
      end
    end
  end
end
