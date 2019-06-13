# frozen_string_literal: true

RSpec.shared_examples "an_attribution" do
  describe ":Alphabetization" do
    let(:instance) { create_minimal_instance }

    it_behaves_like "an_alphabetizable_model"

    describe "#work_alpha_parts" do
      it "is a prefixed method alias to work" do
        expect(instance.work_alpha_parts).to eq(instance.work.alpha_parts)
      end
    end

    describe "#creator_alpha_parts" do
      it "is a prefixed method alias to creator" do
        expect(instance.creator_alpha_parts).to eq(instance.creator.alpha_parts)
      end
    end

    describe "#alpha_parts" do
      it "uses work, role and creator" do
        expect(instance.alpha_parts).to eq([
          instance.work_alpha_parts,
          instance.role_name,
          instance.creator_alpha_parts
        ])
      end
    end
  end

  describe ":CreatorAssociation" do
    it { is_expected.to belong_to(:creator).required }

    it { is_expected.to validate_presence_of(:creator) }
  end

  describe ":StiInheritance" do
    it { is_expected.to validate_presence_of(:type) }

    it "subclasses Attribution" do
      expect(described_class.superclass).to eq(Attribution)
    end
  end

  describe ":WorkAssociation" do
    it { is_expected.to belong_to(:work).required }

    it { is_expected.to validate_presence_of(:work) }

    describe "#display_medium" do
      it "is an unprefixed method alias to work" do
        instance = build_minimal_instance

        expect(instance.display_medium).to eq(instance.work.display_medium)
      end
    end
  end
end
