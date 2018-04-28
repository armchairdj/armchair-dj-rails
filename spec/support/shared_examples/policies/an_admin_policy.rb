# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_admin_policy" do
  subject { described_class.new(user, record) }

  context "as guest" do
    let(:user) { nil }

    it "403s" do
      [
        :index,
        :show,
        :new,
        :create,
        :edit,
        :update,
        :destroy
      ].each do |method|
        expect {
          subject.send("#{method.to_s}?")
        }.to raise_error(Pundit::NotAuthorizedError, "must be admin")
      end
    end
  end

  context "as member" do
    let(:user) { create(:member) }

    it "403s" do
      [
        :index,
        :show,
        :new,
        :create,
        :edit,
        :update,
        :destroy
      ].each do |method|
        expect {
          subject.send("#{method.to_s}?")
        }.to raise_error(Pundit::NotAuthorizedError, "must be admin")
      end
    end
  end

  context "as writer" do
    let(:user) { create(:writer) }

    it "403s" do
      [
        :index,
        :show,
        :new,
        :create,
        :edit,
        :update,
        :destroy
      ].each do |method|
        expect {
          subject.send("#{method.to_s}?")
        }.to raise_error(Pundit::NotAuthorizedError, "must be admin")
      end
    end
  end

  context "as editor" do
    let(:user) { create(:editor) }

    it "403s" do
      [
        :index,
        :show,
        :new,
        :create,
        :edit,
        :update,
        :destroy
      ].each do |method|
        expect {
          subject.send("#{method.to_s}?")
        }.to raise_error(Pundit::NotAuthorizedError, "must be admin")
      end
    end
  end

  context "as admin" do
    let(:user) { create(:admin) }

    specify { is_expected.to permit_actions([
      :index,
      :show,
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end

  context "as super_admin" do
    let(:user) { create(:super_admin) }

    specify { is_expected.to permit_actions([
      :index,
      :show,
      :new,
      :create,
      :edit,
      :update,
      :destroy
    ]) }
  end
end
