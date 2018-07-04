# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_public_policy" do
  let(:record) { create_minimal_instance }

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

  describe "as member" do
    let(:user) { create(:member) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  describe "as writer" do
    let(:user) { create(:writer) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  describe "as editor" do
    let(:user) { create(:editor) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }

    it { is_expected.to forbid_action(:new    ) }
    it { is_expected.to forbid_action(:create ) }
    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:destroy) }
  end

  describe "as admin" do
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

  describe "scope" do
    subject { described_class::Scope.new(user, model_class.all).resolve }

    let(:model_class) { record.class }
    let(       :user) { nil }

    it "uses for_site and resolves" do
       allow(model_class).to receive(:for_site).and_call_original
      expect(model_class).to receive(:for_site)

      is_expected.to be_a_kind_of(ActiveRecord::Relation)
    end
  end
end
