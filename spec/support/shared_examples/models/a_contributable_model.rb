# frozen_string_literal: true

RSpec.shared_examples "a_contributable_model" do
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
    let(:instance) { build_minimal_instance }

    pending "#display_medium"
    pending "#work_alpha_parts"
    pending "#creator_alpha_parts"

    describe "#alpha_parts" do
      subject { create_minimal_instance.alpha_parts }

      it { is_expected.to eq([
        instance.work_alpha_parts,
        instance.role_name,
        instance.creator_alpha_parts
      ]) }
    end
  end
end
