# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article do
  describe "concerns" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [:author] }
      let(:show_loads) { [:author, :links, :tags] }
    end

    it_behaves_like "an_imageable_model"
  end

  describe "STI inheritance" do
    specify { expect(described_class.superclass).to eq(Post) }

    describe "type" do
      subject { described_class.new.type }

      it { is_expected.to eq("Article") }
    end

    describe "#display_type" do
      let(:instance) { build_minimal_instance }

      specify { expect(instance.display_type).to eq("Article") }
      specify { expect(instance.display_type(plural: true)).to eq("Articles") }
    end
  end

  describe "status" do
    it_behaves_like "a_model_with_a_better_enum_for", :status
  end

  describe "title" do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe "sluggable" do
    it_behaves_like "a_sluggable_model"

    describe "#sluggable_parts" do
      subject { instance.sluggable_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.title]) }
    end

    describe "#reset_slug_history" do
      subject(:call_method) { instance.send(:reset_slug_history) }

      let(:instance) do
        instance = create_minimal_instance(:published, title: "foo")
        instance.update!(title: "bar", clear_slug: true)
        instance.update!(title: "bat", clear_slug: true)
        instance
      end

      it "removes all old slugs so they can be reused" do
        expect { call_method }.to change { instance.slugs.count }.from(3).to(0)
      end
    end
  end

  describe "alpha" do
    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      let(:instance) { build_minimal_instance }

      it { is_expected.to eq([instance.title]) }
    end
  end
end
