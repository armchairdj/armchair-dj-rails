# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_feedable_policy" do
  let(     :record) { create_minimal_instance }
  let(:model_class) { record.class }

  subject { described_class.new(user, model_class) }

  context "without user" do
    let(:user) { nil }

    it { is_expected.to permit_action(:feed) }
  end

  describe "as member" do
    let(:user) { create(:member) }

    it { is_expected.to permit_action(:feed) }
  end

  describe "as writer" do
    let(:user) { create(:writer) }

    it { is_expected.to permit_action(:feed) }
  end

  describe "as editor" do
    let(:user) { create(:editor) }

    it { is_expected.to permit_action(:feed) }
  end

  describe "as admin" do
    let(:user) { create(:admin) }

    it { is_expected.to permit_action(:feed) }
  end

  context "as root" do
    let(:user) { create(:root) }

    it { is_expected.to permit_action(:feed) }
  end
end
