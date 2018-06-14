require "rails_helper"

RSpec.describe Podcast, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "STI" do
    context "class" do
      specify { expect(described_class.superclass).to eq(Work) }

      specify { expect(described_class.true_model_name.name ).to eq("Podcast") }
      specify { expect(described_class.true_human_model_name).to eq("Podcast") }
    end

    context "instance" do
      let(:instance) { create_minimal_instance }

      specify { expect(instance.type                 ).to eq("Podcast") }
      specify { expect(instance.true_model_name.name ).to eq("Podcast") }
      specify { expect(instance.true_human_model_name).to eq("Podcast") }
    end
  end

  context "class" do
    pending "self#characteristics"
  end

  context "scope-related" do
    # Nothing so far.
  end

  context "associations" do
    # Nothing so far.
  end

  context "attributes" do
    context "nested" do
      # Nothing so far.
    end

    context "enums" do
      # Nothing so far.
    end
  end

  context "validations" do
    # Nothing so far.

    context "conditional" do
      # Nothing so far.
    end

    context "custom" do
      # Nothing so far.
    end
  end

  context "hooks" do
    # Nothing so far.

    context "callbacks" do
      # Nothing so far.
    end
  end

  context "instance" do
    # Nothing so far.

    describe "private" do
      # Nothing so far.
    end
  end
end
