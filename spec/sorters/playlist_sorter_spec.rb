# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistSorter do
  describe "concerns" do
    it_behaves_like "a_dicer",  Playlist
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
        "Author",
      ]) }
    end
  end
end
