# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoleSorter do
  it_behaves_like "a_ginsu_sorter"

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array(["Default", "ID", "Name", "Medium"]) }
    end

    describe "#model_class" do
      subject { instance.send(:model_class) }

      it { is_expected.to eq(Role) }
    end
  end
end
