# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReviewSorter do
  describe "concerns" do
    it_behaves_like "a_dicer",  Review
    it_behaves_like "a sorter"
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "Default",
        "ID",
        "Title",
        "Status",
        "Author",
        "Medium",
      ]) }
    end
  end
end
