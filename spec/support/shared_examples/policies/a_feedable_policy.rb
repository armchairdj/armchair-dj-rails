# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_feedable_policy" do
  subject { described_class.new(user, determine_model_class) }

  context "without user" do
    let(:user) { nil }

    it { is_expected.to permit_action(:feed) }
  end

  context "with member" do
    let(:user) { build_stubbed(:member) }

    it { is_expected.to permit_action(:feed) }
  end

  context "with writer" do
    let(:user) { build_stubbed(:writer) }

    it { is_expected.to permit_action(:feed) }
  end

  context "with editor" do
    let(:user) { build_stubbed(:editor) }

    it { is_expected.to permit_action(:feed) }
  end

  context "with admin" do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:feed) }
  end

  context "with root user" do
    let(:user) { build_stubbed(:root) }

    it { is_expected.to permit_action(:feed) }
  end
end
