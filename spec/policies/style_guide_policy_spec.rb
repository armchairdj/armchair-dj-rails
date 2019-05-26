# frozen_string_literal: true

require "rails_helper"

RSpec.describe StyleGuidePolicy do
  let(:record) { double }

  subject { described_class.new(user, record) }

  context "without user" do
    let(:user) { nil }

    it { is_expected.to raise_not_authorized_for(:index) }
    it { is_expected.to raise_not_authorized_for(:show) }
    it { is_expected.to raise_not_authorized_for(:flash_message) }
    it { is_expected.to raise_not_authorized_for(:error_page) }
  end

  describe "as member" do
    let(:user) { build_stubbed(:member) }

    it { is_expected.to raise_not_authorized_for(:index) }
    it { is_expected.to raise_not_authorized_for(:show) }
    it { is_expected.to raise_not_authorized_for(:flash_message) }
    it { is_expected.to raise_not_authorized_for(:error_page) }
  end

  describe "as writer" do
    let(:user) { build_stubbed(:writer) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:flash_message) }
    it { is_expected.to permit_action(:error_page) }
  end

  describe "as editor" do
    let(:user) { build_stubbed(:editor) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:flash_message) }
    it { is_expected.to permit_action(:error_page) }
  end

  describe "as admin" do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:flash_message) }
    it { is_expected.to permit_action(:error_page) }
  end

  context "as root" do
    let(:user) { build_stubbed(:root) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:flash_message) }
    it { is_expected.to permit_action(:error_page) }
  end
end
