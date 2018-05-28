# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_admin_policy" do
  subject { described_class.new(user, record) }

  context "without user" do
    let(:user) { nil }

    it { is_expected.to raise_not_authorized_for(:index  ) }
    it { is_expected.to raise_not_authorized_for(:show   ) }
    it { is_expected.to raise_not_authorized_for(:new    ) }
    it { is_expected.to raise_not_authorized_for(:create ) }
    it { is_expected.to raise_not_authorized_for(:edit   ) }
    it { is_expected.to raise_not_authorized_for(:update ) }
    it { is_expected.to raise_not_authorized_for(:destroy) }
  end

  context "as member" do
    let(:user) { create(:member) }

    it { is_expected.to raise_not_authorized_for(:index  ) }
    it { is_expected.to raise_not_authorized_for(:show   ) }
    it { is_expected.to raise_not_authorized_for(:new    ) }
    it { is_expected.to raise_not_authorized_for(:create ) }
    it { is_expected.to raise_not_authorized_for(:edit   ) }
    it { is_expected.to raise_not_authorized_for(:update ) }
    it { is_expected.to raise_not_authorized_for(:destroy) }
  end

  context "as writer" do
    let(:user) { create(:writer) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }
    it { is_expected.to permit_action(:new    ) }
    it { is_expected.to permit_action(:create ) }
    it { is_expected.to permit_action(:edit   ) }
    it { is_expected.to permit_action(:update ) }

    it { is_expected.to forbid_action(:destroy) }
  end

  context "as editor" do
    let(:user) { create(:editor) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }
    it { is_expected.to permit_action(:new    ) }
    it { is_expected.to permit_action(:create ) }
    it { is_expected.to permit_action(:edit   ) }
    it { is_expected.to permit_action(:update ) }

    it { is_expected.to forbid_action(:destroy) }
  end

  context "as admin" do
    let(:user) { create(:editor) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }
    it { is_expected.to permit_action(:new    ) }
    it { is_expected.to permit_action(:create ) }
    it { is_expected.to permit_action(:edit   ) }
    it { is_expected.to permit_action(:update ) }

    it { is_expected.to forbid_action(:destroy) }
  end

  context "as root" do
    let(:user) { create(:root) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }
    it { is_expected.to permit_action(:new    ) }
    it { is_expected.to permit_action(:create ) }
    it { is_expected.to permit_action(:edit   ) }
    it { is_expected.to permit_action(:update ) }
    it { is_expected.to permit_action(:destroy) }
  end
end
