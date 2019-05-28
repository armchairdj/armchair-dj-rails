# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorkSorter do
  it_behaves_like "a_ginsu_sorter"

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array(["Default", "ID", "Makers", "Medium", "Title"]) }
    end

    describe "#model_class" do
      subject { instance.send(:model_class) }

      it { is_expected.to eq(Work) }
    end
  end
end
