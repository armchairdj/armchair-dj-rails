require "rails_helper"

RSpec.describe <%= class_name %>Policy do
  let(:record) { build_minimal_instance }

  context "without user" do
    let(:user) { nil }

    pending "works without user"
  end

  describe "with member" do
    let(:user) { create(:member) }

    pending "works with member"
  end

  describe "with writer" do
    let(:user) { create(:writer) }

    pending "works with writer"
  end

  describe "with editor" do
    let(:user) { create(:editor) }

    pending "works with editor"
  end

  describe "with admin" do
    let(:user) { create(:admin) }

    pending "works with admin"
  end

  context "with root user" do
    let(:user) { create(:root) }

    pending "works with root"
  end

  describe "scope" do
    let(:model_class) { determine_model_class }

    subject { described_class::Scope.new(user, model_class).resolve }

    before(:each) do
      expect(model_class).to receive(:all).and_call_original
    end

    describe "with user" do
      let(:user) { create(:member) }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
    end

    describe "without user" do
      let(:user) { nil }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
    end
  end
end
