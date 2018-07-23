# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReviewScoper do
  describe "concerns" do
    it_behaves_like "a_dicer",  Review
    it_behaves_like "a scoper"
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "All",
        "Draft",
        "Scheduled",
        "Published",
      ]) }
    end
  end
end
