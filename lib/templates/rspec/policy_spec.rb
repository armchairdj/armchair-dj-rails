require "rails_helper"

RSpec.describe <%= class_name %>Policy do
  let(:record) { create_minimal_instance }

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

    let(:model_class) { record.class }
    let(       :user) { nil }

    pending "works"
  end
end
