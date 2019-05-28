# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ginsu::Sorter do
  describe "#class" do
    describe "#prepare_clause" do
      subject { described_class.prepare_clause(clauses, dir) }

      before do
        expect(Arel).to receive(:sql).and_call_original
      end

      context "with a single clause, ascending" do
        let(:clauses) { "name" }
        let(:dir) { "ASC" }

        it { is_expected.to eq("name") }
      end

      context "with multiple clauses, ascending" do
        let(:clauses) { ["name", "created_at"] }
        let(:dir) { "ASC" }

        it { is_expected.to eq("name, created_at") }
      end

      context "with a single clause, descending" do
        let(:clauses) { "name" }
        let(:dir) { "DESC" }

        it { is_expected.to eq("name DESC") }
      end

      context "with multiple clauses, descending" do
        let(:clauses) { ["name", "created_at"] }
        let(:dir) { "DESC" }

        it { is_expected.to eq("name DESC, created_at") }
      end
    end

    describe "#combine_clauses" do
      subject { described_class.combine_clauses(clauses) }

      context "with multiple clauses" do
        let(:clauses) { [" name ASC ", " created_at  DESC "] }

        it "squishes and joins" do
          is_expected.to eq("name ASC, created_at DESC")
        end
      end

      context "with a single clause" do
        let(:clauses) { [" name  ASC "] }

        it "squishes" do
          is_expected.to eq("name ASC")
        end
      end
    end

    describe "#reverse_clause" do
      subject { described_class.reverse_clause(clause) }

      context "with DESC direction" do
        let(:clause) { " name  DESC " }

        it "squishes and makes ASC" do
          is_expected.to eq("name ASC")
        end
      end

      context "with ASC direction" do
        let(:clause) { " name  ASC " }

        it "squishes and makes DESC" do
          is_expected.to eq("name DESC")
        end
      end

      context "with unspecified direction" do
        let(:clause) { " name    " }

        it "squishes and makes DESC" do
          is_expected.to eq("name DESC")
        end
      end
    end
  end

  describe "#constructor" do
    before do
      allow_any_instance_of(described_class).to receive(:allowed).and_return("Default" => "created_at DESC")
    end

    context "with defaults" do
      let(:instance) { described_class.new(current_scope: "", current_sort: "", current_dir: "") }

      describe "sets current_scope to nil" do
        subject { instance.current_scope }

        it { is_expected.to eq(nil) }
      end

      describe "sets current_sort to default" do
        subject { instance.current_sort }

        it { is_expected.to eq("Default") }
      end

      describe "sets current_dir to default" do
        subject { instance.current_dir }

        it { is_expected.to eq("ASC") }
      end
    end

    context "with explicit values" do
      let(:instance) { described_class.new(current_scope: "All", current_sort: "ID", current_dir: "DESC") }

      describe "sets current_scope" do
        subject { instance.current_scope }

        it { is_expected.to eq("All") }
      end

      describe "sets current_sort" do
        subject { instance.current_sort }

        it { is_expected.to eq("ID") }
      end

      describe "sets current_dir" do
        subject { instance.current_dir }

        it { is_expected.to eq("DESC") }
      end
    end
  end
end
