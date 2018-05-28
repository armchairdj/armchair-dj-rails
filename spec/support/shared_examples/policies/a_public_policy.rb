# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_public_policy" do
  subject { described_class.new(user, record) }

  context "without user" do
    let(:user) { nil }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "as member" do
    let(:user) { create(:member) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "as writer" do
    let(:user) { create(:writer) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "as editor" do
    let(:user) { create(:editor) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "as admin" do
    let(:user) { create(:admin) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "as root" do
    let(:user) { create(:root) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
