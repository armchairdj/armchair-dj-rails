# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scoper do
  describe "#constructor" do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:allowed).and_return({
        "Sorted" => :sorted
      })
    end

    context "defaults" do
      let(:instance) { described_class.new(current_scope: "", current_sort: "", current_dir: "") }

      describe "sets current_scope to default" do
        subject { instance.current_scope }

        it { is_expected.to eq("Sorted") }
      end

      describe "sets current_sort to nil" do
        subject { instance.current_sort }

        it { is_expected.to eq(nil) }
      end

      describe "sets current_dir to nil" do
        subject { instance.current_dir }

        it { is_expected.to eq(nil) }
      end
    end

    context "explicit values" do
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
