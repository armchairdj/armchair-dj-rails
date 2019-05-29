require "rails_helper"

RSpec.describe <%= class_name %>Policy do
  let(:record) { build_minimal_instance }

  context "without user" do
    let(:user) { nil }

    pending "works without user"
  end

  context "with member" do
    let(:user) { create(:member) }

    pending "works with member"
  end

  context "with writer" do
    let(:user) { create(:writer) }

    pending "works with writer"
  end

  context "with editor" do
    let(:user) { create(:editor) }

    pending "works with editor"
  end

  context "with admin" do
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

    context "with user" do
      let(:user) { create(:member) }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
    end

    context "without user" do
      let(:user) { nil }

      it { is_expected.to be_a_kind_of(ActiveRecord::Relation) }
    end
  end
end
