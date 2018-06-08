# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::MediumPolicy do
  it_behaves_like "an_admin_policy"

  describe "reorder_facets?" do
    let(:record) { create(:minimal_medium) }

    subject { described_class.new(user, record) }

    context "without user" do
      let(:user) { nil }

      it { is_expected.to raise_not_authorized_for(:reorder_facets) }
    end

    context "as member" do
      let(:user) { create(:member) }

      it { is_expected.to raise_not_authorized_for(:reorder_facets) }
    end

    context "as writer" do
      let(:user) { create(:writer) }

      it { is_expected.to permit_action(:reorder_facets) }
    end

    context "as editor" do
      let(:user) { create(:editor) }

      it { is_expected.to permit_action(:reorder_facets) }
    end

    context "as admin" do
      let(:user) { create(:editor) }

      it { is_expected.to permit_action(:reorder_facets) }
    end

    context "as root" do
      let(:user) { create(:root) }

      it { is_expected.to permit_action(:reorder_facets) }
    end
  end
end
