# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoGame do
  it_behaves_like "a_medium"

  describe ":StiInheritance" do
    describe "class" do
      specify { expect(described_class.superclass).to eq(Medium) }
      specify { expect(described_class.model_name.name).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("VideoGame") }
      specify { expect(described_class.display_medium).to eq("Video Game") }
    end

    describe "instance" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.model_name.name).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("VideoGame") }
      specify { expect(instance.medium).to eq("VideoGame") }
      specify { expect(instance.display_medium).to eq("Video Game") }
    end
  end

  describe "class attributes" do
    describe "available_aspects" do
      let(:expected) { [:game_mechanic, :tech_platform, :game_studio] }
      let(:instance) { build_minimal_instance }

      specify { expect(instance.available_aspects).to eq(expected) }
      specify { expect(described_class.available_aspects).to eq(expected) }
    end
  end
end
