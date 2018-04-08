require "rails_helper"

RSpec.shared_examples "a public policy" do
  subject { described_class.new(user, record) }

  context "as guest" do
    let(:user) { create(:guest) }

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

  context "as contributor" do
    let(:user) { create(:contributor) }

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
end
