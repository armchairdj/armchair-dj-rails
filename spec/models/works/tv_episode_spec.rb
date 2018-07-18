require "rails_helper"

RSpec.describe TvEpisode, type: :model do
  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass          ).to eq(Medium) }
      specify { expect(described_class.model_name.name     ).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("TvEpisode") }
      specify { expect(described_class.display_medium      ).to eq("TV Episode") }
    end

    describe "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.model_name.name     ).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("TvEpisode") }
      specify { expect(instance.medium              ).to eq("TvEpisode") }
      specify { expect(instance.display_medium      ).to eq("TV Episode") }
    end
  end

  describe "class attributes" do
    describe "available_facets" do
      let(:expected) { [:narrative_genre, :tv_network, :hollywood_studio] }
      let(:instance) { create_minimal_instance }

      specify { expect(       instance.available_facets).to eq(expected) }
      specify { expect(described_class.available_facets).to eq(expected) }
    end
  end
end
