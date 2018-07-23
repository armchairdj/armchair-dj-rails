# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ginsu::Collection do
  describe "constructor" do
    context "arguments" do
      let(:relation) { Tag.for_list }

      before(:each) do
         allow( TagScoper).to receive(:new)
         expect(TagScoper).to receive(:new)

         allow( TagSorter).to receive(:new).with(**expected_args)
         expect(TagSorter).to receive(:new).with(**expected_args)
      end

      context "without keyword arguments" do
        let(:expected_args) { { current_scope: nil, current_sort: nil, current_dir: nil } }

        it "builds utility classes correctly" do
          described_class.new(relation)
        end
      end

      context "with keyword arguments" do
        let(:expected_args) { { current_scope: "scope", current_sort: "sort", current_dir: "dir" } }

        it "builds utility classes correctly" do
          described_class.new(relation, scope: "scope", sort: "sort", dir: "dir", page: "page")
        end
      end
    end

    context "with a model that is" do
      context "vanilla" do
        before(:each) do
           allow( AspectScoper).to receive(:new)
           expect(AspectScoper).to receive(:new)

           allow( AspectSorter).to receive(:new)
           expect(AspectSorter).to receive(:new)
        end

        it "builds scopers and sorters based on the relation's class" do
          described_class.new(Aspect.for_list)
        end
      end

      context "STI" do
        context "with multiple subclasses but one controller" do
          before(:each) do
             allow( WorkScoper).to receive(:new)
             expect(WorkScoper).to receive(:new)

             allow( WorkSorter).to receive(:new)
             expect(WorkSorter).to receive(:new)
          end

          it "builds scopers and sorters based on the relation's superclass" do
            described_class.new(Song.for_list)
          end
        end

        context "with multiple subclasses and controllers" do
          before(:each) do
             allow( ArticleScoper).to receive(:new)
             expect(ArticleScoper).to receive(:new)

             allow( ArticleSorter).to receive(:new)
             expect(ArticleSorter).to receive(:new)
          end

          it "builds scopers and sorters based on the relation's class" do
            described_class.new(Article.for_list)
          end
        end
      end
    end

    context "instance variables" do
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

        context "default" do
          it { is_expected.to eq("1") }
        end

        context "specific" do
          let(:instance) { described_class.new(relation, page: "2") }

          it { is_expected.to eq("2") }
        end
      end
    end
  end

  describe "instance" do
    describe "#resolve" do
      let(:relation) { Creator.for_list }
      let(:instance) { described_class.new(relation, page: "2") }

      subject { instance.resolve }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }

      it "resolves the scoper" do
        allow( instance.scoper).to receive(:resolve).and_call_original
        expect(instance.scoper).to receive(:resolve)

        subject
      end

      it "resolves the sorter" do
        allow( instance.sorter).to receive(:resolve).and_call_original
        expect(instance.sorter).to receive(:resolve)

        subject
      end

      it "rolls it all up and paginates" do
        allow(instance.scoper).to receive(:resolve).and_return(:all)
        allow(instance.sorter).to receive(:resolve).and_return("created_at DESC")

        allow_any_instance_of(ActiveRecord::Relation).to receive(:order).and_call_original
        allow( Creator).to receive(:page).and_call_original
        allow( Creator).to receive(:all ).and_call_original

        expect_any_instance_of(ActiveRecord::Relation).to receive(:order).with("created_at DESC")
        expect(Creator).to receive(:all)
        expect(Creator).to receive(:page).with("2")

        subject
      end
    end
  end
end
