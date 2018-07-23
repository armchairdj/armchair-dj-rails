require "rails_helper"

RSpec.describe <%= class_name %>Policy do
  let(     :record) { create_minimal_instance }
  let(:model_class) { record.class }

  context "without user" do
    let(:user) { nil }

    pending "works without user"
  end

  describe "as member" do
    let(:user) { create(:member) }

    pending "works with member"
  end

  describe "as writer" do
    let(:user) { create(:writer) }

    pending "works with writer"
  end

  describe "as editor" do
    let(:user) { create(:editor) }

    pending "works with editor"
  end

  describe "as admin" do
    let(:user) { create(:admin) }

    pending "works with admin"
  end

  context "as root" do
    let(:user) { create(:root) }

    pending "works with root"
  end

  describe "scope" do
    subject { described_class::Scope.new(user, model_class.all).resolve }

    before(:each) do
      allow( model_class).to receive(:all).and_call_original
      expect(model_class).to receive(:all)
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
