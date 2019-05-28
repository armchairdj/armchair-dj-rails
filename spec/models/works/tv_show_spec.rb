# frozen_string_literal: true

require "rails_helper"

RSpec.describe TvShow do
  it_behaves_like "a_medium"

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass).to eq(Medium) }
      specify { expect(described_class.model_name.name).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("TvShow") }
      specify { expect(described_class.display_medium).to eq("TV Show") }
    end

    describe "instance" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.model_name.name).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("TvShow") }
      specify { expect(instance.medium).to eq("TvShow") }
      specify { expect(instance.display_medium).to eq("TV Show") }
    end
  end

  describe "class attributes" do
    describe "available_facets" do
      let(:expected) { [:narrative_genre, :tv_network, :hollywood_studio] }
      let(:instance) { build_minimal_instance }

      specify { expect(instance.available_facets).to eq(expected) }
      specify { expect(described_class.available_facets).to eq(expected) }
    end
  end
end
