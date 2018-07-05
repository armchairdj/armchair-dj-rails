require "rails_helper"

RSpec.describe Gadget, type: :model do
  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass           ).to eq(Medium) }
      specify { expect(described_class.model_name.name      ).to eq("Work") }
      specify { expect(described_class.true_model_name.name ).to eq("Gadget") }
      specify { expect(described_class.true_human_model_name).to eq("Gadget") }
    end

    describe "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.model_name.name      ).to eq("Work") }
      specify { expect(instance.medium               ).to eq("Gadget") }
      specify { expect(instance.true_model_name.name ).to eq("Gadget") }
      specify { expect(instance.true_human_model_name).to eq("Gadget") }
    end
  end

  describe "class" do
    pending "self#available_facets"
  end

  describe "instance" do
    describe "role methods" do
      pending "#available_roles"
      pending "#available_role_ids"
    end
  end
end
