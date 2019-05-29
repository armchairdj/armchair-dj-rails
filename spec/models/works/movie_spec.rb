# frozen_string_literal: true

require "rails_helper"

RSpec.describe Movie do
  it_behaves_like "a_medium"

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass).to eq(Medium) }
      specify { expect(described_class.model_name.name).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("Movie") }
      specify { expect(described_class.display_medium).to eq("Movie") }
    end

    describe "instance" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.model_name.name).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("Movie") }
      specify { expect(instance.medium).to eq("Movie") }
      specify { expect(instance.display_medium).to eq("Movie") }
    end
  end

  describe "class attributes" do
    describe "available_facets" do
      let(:expected) { [:hollywood_studio, :narrative_genre] }
      let(:instance) { build_minimal_instance }

      specify { expect(instance.available_facets).to eq(expected) }
      specify { expect(described_class.available_facets).to eq(expected) }
    end
  end
end
