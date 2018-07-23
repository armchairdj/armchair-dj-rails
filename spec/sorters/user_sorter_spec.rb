# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserSorter do
  describe "concerns" do
    it_behaves_like "a_dicer",  User
    it_behaves_like "a sorter"
  end

  describe "instance" do
    let(:instance) { described_class.new }

    describe "#allowed" do
      subject { instance.allowed.keys }

      it { is_expected.to match_array([
        "Default",
        "ID",
        "Name",
        "Username",
        "Email",
        "Role",
      ]) }
    end
  end
end
