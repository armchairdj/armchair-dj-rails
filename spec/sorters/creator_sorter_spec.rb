# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorSorter do
  describe "concerns" do
    it_behaves_like "a_dicer",  Creator
    it_behaves_like "a_sorter", Creator
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "Default",
        "ID",
        "Name",
        "Primary",
        "Individual",
      ]) }
    end
  end
end
