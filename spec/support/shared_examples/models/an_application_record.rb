# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_application_record" do
  # Most concerns are tested in the models that actually use them.
  it_behaves_like "an_atomically_validatable_model"

  describe ":AssociationUtilities" do
    pending ".by_association"

    describe ".ids_from_list" do
      let(:instances) { create_minimal_list(2) }
      let(:association) { described_class.where(id: instances.map(&:id)) }

      it "turns `[nil]` into an empty array" do
        expect(described_class.ids_from_list([nil])).to eq([])
      end

      it "turns `nil` into an empty array" do
        expect(described_class.ids_from_list(nil)).to eq([])
      end

      it "turns `[instance1]` into an array with a single id" do
        expect(described_class.ids_from_list([instances[0]])).to eq([instances[0].id])
      end

      it "turns `instance1` into an array with a single id" do
        expect(described_class.ids_from_list(instances[0])).to eq([instances[0].id])
      end

      it "turns `[instance1, instance2]` array of ids" do
        expect(described_class.ids_from_list(instances)).to eq([instances[0].id, instances[1].id])
      end

      it "turns `instance1, instance2` into an array of ids" do
        expect(described_class.ids_from_list(*instances)).to eq([instances[0].id, instances[1].id])
      end

      it "turns `association` into an array of ids" do
        expect(described_class.ids_from_list(association)).to eq([instances[0].id, instances[1].id])
      end
    end
  end

  describe ".find_by_sorted_ids" do
    let(:instances) do
      [
        create_minimal_instance,
        create_minimal_instance,
        create_minimal_instance
      ]
    end

    context "with full array of ids" do
      subject { described_class.find_by_sorted_ids(ids) }

      let(:ids) { [instances[1].id, instances[0].id, instances[2].id] }

      it "gives relation ordered by array order" do
        is_expected.to be_a_kind_of(ActiveRecord::Relation)

        is_expected.to eq([
          instances[1],
          instances[0],
          instances[2]
        ])
      end
    end

    context "with empty array of ids" do
      subject { described_class.find_by_sorted_ids(ids) }

      let(:ids) { [] }

      it "gives empty relation" do
        is_expected.to eq(described_class.none)
      end
    end
  end

  describe ".validates_nested_uniqueness_of" do
    it "is defined" do
      expect(described_class).to respond_to(:validates_nested_uniqueness_of)
    end
  end
end
