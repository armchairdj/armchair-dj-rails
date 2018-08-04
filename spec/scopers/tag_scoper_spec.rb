# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagScoper do
  describe "concerns" do
    it_behaves_like "a_ginsu_scoper"
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "All",
      ]) }
    end

    context "private" do
      describe "#model_class" do
        subject { instance.send(:model_class) }

        it { is_expected.to eq(Tag) }
      end
    end
  end
end