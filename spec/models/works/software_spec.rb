require "rails_helper"

RSpec.describe Software, type: :model do
  describe "constants" do
    # Nothing so far.
  end

  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass           ).to eq(Medium) }
      specify { expect(described_class.model_name.name      ).to eq("Work") }
      specify { expect(described_class.true_model_name.name ).to eq("Software") }
      specify { expect(described_class.true_human_model_name).to eq("Software") }
    end

    describe "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.model_name.name      ).to eq("Work") }
      specify { expect(instance.type                 ).to eq("Software") }
      specify { expect(instance.true_model_name.name ).to eq("Software") }
      specify { expect(instance.true_human_model_name).to eq("Software") }
    end
  end

  describe "class" do
    pending "self#facets"
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "associations" do
    # Nothing so far.
  end

  describe "attributes" do
    describe "nested" do
      # Nothing so far.
    end

    describe "enums" do
      # Nothing so far.
    end
  end

  describe "validations" do
    # Nothing so far.

    describe "conditional" do
      # Nothing so far.
    end

    describe "custom" do
      # Nothing so far.
    end
  end

  describe "hooks" do
    # Nothing so far.

    describe "callbacks" do
      # Nothing so far.
    end
  end

  describe "instance" do
    # Nothing so far.

    describe "private" do
      # Nothing so far.
    end
  end
end
