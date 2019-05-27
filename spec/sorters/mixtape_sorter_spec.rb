# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapeSorter do
  describe "concerns" do
    it_behaves_like "a_ginsu_sorter"
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array(%w[Default ID Title Status Author]) }
    end

    context "private" do
      describe "#model_class" do
        subject { instance.send(:model_class) }

        it { is_expected.to eq(Mixtape) }
      end
    end
  end
end
