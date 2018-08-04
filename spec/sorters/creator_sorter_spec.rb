# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorSorter do
  describe "concerns" do
    it_behaves_like "a_ginsu_sorter"
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "Default",
        "ID",
        "Name",
        "Creator Type",
        "Identity Type",
      ]) }
    end

    context "private" do
      describe "#model_class" do
        subject { instance.send(:model_class) }

        it { is_expected.to eq(Creator) }
      end
    end
  end
end