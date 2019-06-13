# frozen_string_literal: true

require "rails_helper"

RSpec.describe Podcast do
  it_behaves_like "a_medium"

  describe ":StiInheritance" do
    describe "class" do
      specify { expect(described_class.superclass).to eq(Medium) }
      specify { expect(described_class.model_name.name).to eq("Work") }
      specify { expect(described_class.true_model_name.name).to eq("Podcast") }
      specify { expect(described_class.display_medium).to eq("Podcast") }
    end

    describe "instance" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.model_name.name).to eq("Work") }
      specify { expect(instance.true_model_name.name).to eq("Podcast") }
      specify { expect(instance.medium).to eq("Podcast") }
      specify { expect(instance.display_medium).to eq("Podcast") }
    end
  end

  describe "class attributes" do
    describe "available_aspects" do
      let(:expected) { [:audio_show_format, :narrative_genre, :podcast_network] }
      let(:instance) { build_minimal_instance }

      specify { expect(instance.available_aspects).to eq(expected) }
      specify { expect(described_class.available_aspects).to eq(expected) }
    end
  end
end
