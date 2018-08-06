# frozen_string_literal: true

RSpec.shared_examples "an_attribution" do
  describe "included" do
    describe "associations" do
      it { is_expected.to belong_to(:creator) }
      it { is_expected.to belong_to(:work   ) }
    end

    describe "validations" do
      subject { build_minimal_instance }

      it { is_expected.to validate_presence_of(:creator) }
      it { is_expected.to validate_presence_of(:work   ) }
    end
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }

    describe "#display_medium" do
      it "is an unprefixed method alias to work" do
        expect(instance.display_medium).to eq(instance.work.display_medium)
      end
    end

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
      subject { instance.alpha_parts }

      it { is_expected.to eq([
        instance.work_alpha_parts,
        instance.role_name,
        instance.creator_alpha_parts
      ]) }
    end
  end
end
