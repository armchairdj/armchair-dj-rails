require "rails_helper"

RSpec.describe TvSeason, type: :model do
  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass          ).to eq(Medium) }
      specify { expect(described_class.model_name.name     ).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("TvSeason") }
      specify { expect(described_class.display_medium      ).to eq("TV Season") }
    end

    describe "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.model_name.name     ).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("TvSeason") }
      specify { expect(instance.medium              ).to eq("TvSeason") }
      specify { expect(instance.display_medium      ).to eq("TV Season") }
    end
  end

  describe "class" do
    pending "self#available_facets"
  end

  describe "instance" do
    # Nothing so far.
  end
end
