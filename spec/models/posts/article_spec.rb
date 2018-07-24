# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article do
  describe "concerns" do
    it_behaves_like "an_eager_loadable_model" do
      let(:list_loads) { [:author] }
      let(:show_loads) { [:author, :links, :tags] }
    end
  end

  describe "class" do
    specify { expect(described_class.superclass).to eq(Post) }
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "associations" do
    # Nothing so far.
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:title) }
  end

  describe "instance" do
    let(:instance) { build_minimal_instance }

    describe "#display_type" do
      specify { expect(instance.display_type              ).to eq("Article" ) }
      specify { expect(instance.display_type(plural: true)).to eq("Articles") }
    end

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      it { is_expected.to eq([instance.title]) }
    end

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([instance.title]) }
    end
  end
end
