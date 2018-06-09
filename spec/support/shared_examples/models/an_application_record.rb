# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_application_record" do
  context "concerns" do
    # Most concerns are tested in the models that actually use them.

    it_behaves_like "an_atomically_validatable_model"
  end

  context "class" do
    describe "self#find_by_sorted_ids" do
      let(:instances) { [
        create_minimal_instance,
        create_minimal_instance,
        create_minimal_instance
      ] }

      context "with full array of ids" do
        let(:ids) { [instances[1].id, instances[0].id, instances[2].id] }

        subject { described_class.find_by_sorted_ids(ids) }

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
        let(:ids) { [] }

        subject { described_class.find_by_sorted_ids(ids) }

        it "gives empty relation" do
          is_expected.to eq(described_class.none)
        end
      end
    end

    describe "self#validate_nested_uniqueness_of" do
      it "is defined" do
        expect(described_class).to respond_to(:validate_nested_uniqueness_of)
      end
    end
  end

  context "included" do
    subject { create_minimal_instance }

    describe "nilify_blanks" do
      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end
end
