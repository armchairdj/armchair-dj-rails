# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorkSorter do
  describe "concerns" do
    it_behaves_like "a_dicer",  Work
    it_behaves_like "a_sorter", Work
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "Default",
        "ID",
        "Makers",
        "Medium",
        "Title"
      ]) }
    end
  end
end
