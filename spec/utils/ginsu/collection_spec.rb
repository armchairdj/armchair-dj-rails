# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ginsu::Collection do
  describe "constructor" do
    let(:relation) { Tag.for_list }

    context "without keyword arguments" do
      let(:expected_args) { { current_scope: nil, current_sort: nil, current_dir: nil } }

      it "builds utility classes correctly" do
        expect(TagScoper).to receive(:new)
        expect(TagSorter).to receive(:new).with(**expected_args)

        described_class.new(relation)
      end
    end

    context "with keyword arguments" do
      let(:expected_args) { { current_scope: "scope", current_sort: "sort", current_dir: "dir" } }

      it "builds utility classes correctly" do
        expect(TagScoper).to receive(:new)
        expect(TagSorter).to receive(:new).with(**expected_args)

        described_class.new(relation, scope: "scope", sort: "sort", dir: "dir", page: "page")
      end
    end

    context "with a vanilla model" do
      before do
        expect(AspectScoper).to receive(:new)
        expect(AspectSorter).to receive(:new)
      end

      it "builds scopers and sorters based on the relation's class" do
        described_class.new(Aspect.for_list)
      end
    end

    context "with and STI model with multiple subclasses but one controller" do
      before do
        expect(WorkScoper).to receive(:new)
        expect(WorkSorter).to receive(:new)
      end

      it "builds scopers and sorters based on the relation's superclass" do
        described_class.new(Song.for_list)
      end
    end

    context "with and STI model with multiple subclasses and controllers" do
      before do
        expect(ArticleScoper).to receive(:new)
        expect(ArticleSorter).to receive(:new)
      end

      it "builds scopers and sorters based on the relation's class" do
        described_class.new(Article.for_list)
      end
    end

    describe "instance variables" do
      let(:relation) { Tag.for_list }
      let(:instance) { described_class.new(relation) }

      describe "@relation" do
        subject { instance.instance_variable_get(:"@relation") }

        it { is_expected.to eq(relation) }
      end

      describe "@model_class" do
        subject { instance.instance_variable_get(:"@model_class") }

        it { is_expected.to eq(Tag) }
      end

      describe "@scoper" do
        subject { instance.instance_variable_get(:"@scoper") }

        it { is_expected.to be_a_kind_of(Ginsu::Scoper) }
      end

      describe "@sorter" do
        subject { instance.instance_variable_get(:"@sorter") }

        it { is_expected.to be_a_kind_of(Ginsu::Sorter) }
      end

      describe "@page" do
        subject { instance.instance_variable_get(:"@page") }

        it "uses default value" do
          is_expected.to eq("1")
        end

        it "allows specific value" do
          instance = described_class.new(relation, page: "2")

          actual = instance.instance_variable_get(:"@page")

          expect(actual).to eq("2")
        end
      end
    end
  end

  describe "#resolved" do
    subject(:call_method) { instance.resolved }

    let(:relation) { Creator.for_list }
    let(:instance) { described_class.new(relation, page: "2") }

    it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }

    it "resolves the scoper" do
      expect(instance.scoper).to receive(:resolved).and_call_original

      call_method
    end

    it "resolves the sorter" do
      expect(instance.sorter).to receive(:resolved).and_call_original

      call_method
    end

    it "rolls it all up and paginates" do
      allow(instance.scoper).to receive(:resolved).and_return(:all)
      allow(instance.sorter).to receive(:resolved).and_return("created_at DESC")

      expect_any_instance_of(ActiveRecord::Relation).to receive(:order).with("created_at DESC").and_call_original

      expect(Creator).to receive(:all).at_least(:once).and_call_original
      expect(Creator).to receive(:page).with("2").and_call_original

      call_method
    end
  end

  describe "#display_count" do
    subject { instance.display_count }

    let(:relation) { Creator.for_list }
    let(:instance) { described_class.new(relation) }
    let(:collection) { double }

    before do
      allow(instance).to receive(:resolved).and_return(collection)
    end

    context "with 0 records" do
      before { allow(collection).to receive(:total_count).and_return(0) }

      it { is_expected.to eq("0 Total Records") }
    end

    context "with 1 record" do
      before { allow(collection).to receive(:total_count).and_return(1) }

      it { is_expected.to eq("1 Total Record") }
    end

    context "with >1 records" do
      before { allow(collection).to receive(:total_count).and_return(2) }

      it { is_expected.to eq("2 Total Records") }
    end
  end
end
