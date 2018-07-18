require "rails_helper"

RSpec.describe Product, type: :model do
  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass          ).to eq(Medium) }
      specify { expect(described_class.model_name.name     ).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("Product") }
      specify { expect(described_class.display_medium      ).to eq("Product") }
    end

    describe "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.model_name.name     ).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("Product") }
      specify { expect(instance.medium              ).to eq("Product") }
      specify { expect(instance.display_medium      ).to eq("Product") }
    end
  end

  describe "class attributes" do
    describe "available_facets" do
      let(:expected) { [:manufacturer, :product_type] }
      let(:instance) { create_minimal_instance }

      specify { expect(       instance.available_facets).to eq(expected) }
      specify { expect(described_class.available_facets).to eq(expected) }
    end
  end
end
