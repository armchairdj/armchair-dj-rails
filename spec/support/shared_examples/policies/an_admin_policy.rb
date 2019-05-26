# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_admin_policy" do
  let(:record) { stub_minimal_instance }

  subject { described_class.new(user, record) }

  context "without user" do
    let(:user) { nil }

    it { is_expected.to raise_not_authorized_for(:index) }
    it { is_expected.to raise_not_authorized_for(:show) }
    it { is_expected.to raise_not_authorized_for(:new) }
    it { is_expected.to raise_not_authorized_for(:create) }
    it { is_expected.to raise_not_authorized_for(:edit) }
    it { is_expected.to raise_not_authorized_for(:update) }
    it { is_expected.to raise_not_authorized_for(:destroy) }
  end

  describe "as member" do
    let(:user) { build_stubbed(:member) }

    it { is_expected.to raise_not_authorized_for(:index) }
    it { is_expected.to raise_not_authorized_for(:show) }
    it { is_expected.to raise_not_authorized_for(:new) }
    it { is_expected.to raise_not_authorized_for(:create) }
    it { is_expected.to raise_not_authorized_for(:edit) }
    it { is_expected.to raise_not_authorized_for(:update) }
    it { is_expected.to raise_not_authorized_for(:destroy) }
  end

  describe "as writer" do
    let(:user) { build_stubbed(:writer) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.to forbid_action(:destroy) }
  end

  describe "as editor" do
    let(:user) { build_stubbed(:editor) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.to forbid_action(:destroy) }
  end

  describe "as admin" do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }

    it { is_expected.to forbid_action(:destroy) }
  end

  context "as root" do
    let(:user) { build_stubbed(:root) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  describe "scope" do
    let(:model_class) { determine_model_class }

    subject { described_class::Scope.new(user, model_class).resolve }

    before(:each) do
      expect(model_class).to receive(:all).and_call_original
    end

    describe "with user" do
      let(:user) { build_stubbed(:writer) }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
    end

    describe "without user" do
      let(:user) { nil }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
    end
  end
end
