# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_admin_post_policy" do
  let(:record) { create_minimal_instance }

  subject { described_class.new(user, record) }

  context "without user" do
    let(:user) { nil }

    it { is_expected.to raise_not_authorized_for(:index  ) }
    it { is_expected.to raise_not_authorized_for(:show   ) }
    it { is_expected.to raise_not_authorized_for(:new    ) }
    it { is_expected.to raise_not_authorized_for(:create ) }
    it { is_expected.to raise_not_authorized_for(:edit   ) }
    it { is_expected.to raise_not_authorized_for(:update ) }
    it { is_expected.to raise_not_authorized_for(:publish) }
    it { is_expected.to raise_not_authorized_for(:destroy) }
  end

  describe "as member" do
    let(:user) { create(:member) }

    it { is_expected.to raise_not_authorized_for(:index  ) }
    it { is_expected.to raise_not_authorized_for(:show   ) }
    it { is_expected.to raise_not_authorized_for(:new    ) }
    it { is_expected.to raise_not_authorized_for(:create ) }
    it { is_expected.to raise_not_authorized_for(:edit   ) }
    it { is_expected.to raise_not_authorized_for(:update ) }
    it { is_expected.to raise_not_authorized_for(:publish) }
    it { is_expected.to raise_not_authorized_for(:destroy) }
  end

  describe "as writer" do
    let(:user) { create(:writer) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }
    it { is_expected.to permit_action(:new    ) }
    it { is_expected.to permit_action(:create ) }

    it { is_expected.to forbid_action(:edit   ) }
    it { is_expected.to forbid_action(:update ) }
    it { is_expected.to forbid_action(:publish) }
    it { is_expected.to forbid_action(:destroy) }

    context "with own record" do
      let(:record) { create_minimal_instance(author_id: user.id) }

      it { is_expected.to permit_action(:index  ) }
      it { is_expected.to permit_action(:show   ) }
      it { is_expected.to permit_action(:new    ) }
      it { is_expected.to permit_action(:create ) }
      it { is_expected.to permit_action(:edit   ) }
      it { is_expected.to permit_action(:update ) }

      it { is_expected.to forbid_action(:publish) }
      it { is_expected.to forbid_action(:destroy) }
    end
  end

  describe "as editor" do
    let(:user) { create(:editor) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }
    it { is_expected.to permit_action(:new    ) }
    it { is_expected.to permit_action(:create ) }
    it { is_expected.to permit_action(:edit   ) }
    it { is_expected.to permit_action(:update ) }

    it { is_expected.to forbid_action(:publish) }
    it { is_expected.to forbid_action(:destroy) }
  end

  describe "as admin" do
    let(:user) { create(:admin) }

    it { is_expected.to permit_action(:index  ) }
    it { is_expected.to permit_action(:show   ) }
    it { is_expected.to permit_action(:new    ) }
    it { is_expected.to permit_action(:create ) }
    it { is_expected.to permit_action(:edit   ) }
    it { is_expected.to permit_action(:update ) }
    it { is_expected.to permit_action(:publish) }

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
    it { is_expected.to permit_action(:publish) }
    it { is_expected.to permit_action(:destroy) }
  end

  describe "scope" do
    subject { described_class::Scope.new(user, model_class.all).resolve }

    let(:model_class) { record.class }
    let(       :user) { create(:writer) }

    pending "for member"
    pending "for writer"
    pending "for editor"
    pending "for admin"
    pending "for root"
  end
end
