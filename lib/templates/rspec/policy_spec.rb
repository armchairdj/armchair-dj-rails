require "rails_helper"

RSpec.describe <%= class_name %>Policy do
  let(     :record) { create_minimal_instance }
  let(:model_class) { record.class }

  context "without user" do
    let(:user) { nil }

    pending "works"
  end

  describe "as member" do
    let(:user) { create(:member) }

    pending "works"
  end

  describe "as writer" do
    let(:user) { create(:writer) }

    pending "works"
  end

  describe "as editor" do
    let(:user) { create(:editor) }

    pending "works"
  end

  describe "as admin" do
    let(:user) { create(:admin) }

    pending "works"
  end

  context "as root" do
    let(:user) { create(:root) }

    pending "works"
  end

  describe "scope" do
    subject { described_class::Scope.new(user, model_class.all).resolve }

    before(:each) do
      allow( model_class).to receive(:all).and_call_original
      expect(model_class).to receive(:all)#.with(user)
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
