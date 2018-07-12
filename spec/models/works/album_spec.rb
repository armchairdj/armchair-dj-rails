require "rails_helper"

RSpec.describe Album, type: :model do
  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass          ).to eq(Medium) }
      specify { expect(described_class.model_name.name     ).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("Album") }
      specify { expect(described_class.display_medium      ).to eq("Album") }
    end

    describe "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.model_name.name     ).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("Album") }
      specify { expect(instance.medium              ).to eq("Album") }
      specify { expect(instance.display_medium      ).to eq("Album") }
    end
  end
end
