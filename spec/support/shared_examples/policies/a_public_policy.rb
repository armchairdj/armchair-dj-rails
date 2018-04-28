# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_public_policy" do
  subject { described_class.new(user, record) }

  context "as guest" do
    let(:user) { nil }

    specify { is_expected.to permit_actions([
      :index,
      :show
    ]) }

    specify { is_expected.to forbid_actions([
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end

  context "as member" do
    let(:user) { create(:member) }

    specify { is_expected.to permit_actions([
      :index,
      :show
    ]) }

    specify { is_expected.to forbid_actions([
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end

  context "as writer" do
    let(:user) { create(:writer) }

    specify { is_expected.to permit_actions([
      :index,
      :show
    ]) }

    specify { is_expected.to forbid_actions([
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end

  context "as editor" do
    let(:user) { create(:editor) }

    specify { is_expected.to permit_actions([
      :index,
      :show
    ]) }

    specify { is_expected.to forbid_actions([
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end

  context "as admin" do
    let(:user) { create(:admin) }

    specify { is_expected.to permit_actions([
      :index,
      :show
    ]) }

    specify { is_expected.to forbid_actions([
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end

  context "as admin" do
    let(:user) { create(:super_admin) }

    specify { is_expected.to permit_actions([
      :index,
      :show
    ]) }

    specify { is_expected.to forbid_actions([
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end
end
