require "rails_helper"

RSpec.describe Song do
  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass          ).to eq(Medium) }
      specify { expect(described_class.model_name.name     ).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("Song") }
      specify { expect(described_class.display_medium      ).to eq("Song") }
    end

    describe "instance" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.model_name.name     ).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("Song") }
      specify { expect(instance.medium              ).to eq("Song") }
      specify { expect(instance.display_medium      ).to eq("Song") }
    end
  end

  describe "class attributes" do
    describe "available_facets" do
      let(:expected) { [:song_type, :musical_genre, :musical_mood, :music_label] }
      let(:instance) { build_minimal_instance }

      specify { expect(       instance.available_facets).to eq(expected) }
      specify { expect(described_class.available_facets).to eq(expected) }
    end
  end
end
