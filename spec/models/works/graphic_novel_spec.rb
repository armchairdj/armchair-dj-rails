require "rails_helper"

RSpec.describe GraphicNovel, type: :model do
  describe "concerns" do
    it_behaves_like "a_medium"
  end

  describe "STI" do
    describe "class" do
      specify { expect(described_class.superclass          ).to eq(Medium) }
      specify { expect(described_class.model_name.name     ).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("GraphicNovel") }
      specify { expect(described_class.display_medium      ).to eq("Graphic Novel") }
    end

    describe "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.model_name.name     ).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("GraphicNovel") }
      specify { expect(instance.medium              ).to eq("GraphicNovel") }
      specify { expect(instance.display_medium      ).to eq("Graphic Novel") }
    end
  end

  describe "class" do
    pending "self#available_facets"
  end

  describe "instance" do
    # Nothing so far.
  end
end
