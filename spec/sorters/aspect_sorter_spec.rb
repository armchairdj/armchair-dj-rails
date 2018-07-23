# frozen_string_literal: true

require "rails_helper"

RSpec.describe AspectSorter do
  describe "concerns" do
    it_behaves_like "a_dicer",  Aspect
    it_behaves_like "a_sorter", Aspect
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "Default",
        "ID",
        "Facet",
        "Name",
      ]) }
    end
  end
end
