require "rails_helper"

RSpec.describe StyleGuidePolicy do
  let(:record) { true }

  subject { described_class.new(user, record) }

  context "as guest" do
    let(:user) { nil }

    it "403s" do
      [
        :index,
        :show,
        :flash_message,
        :error_page
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
        :flash_message,
        :error_page
      ].each do |method|
        expect {
          subject.send("#{method.to_s}?")
        }.to raise_error(Pundit::NotAuthorizedError, "must be admin")
      end
    end
  end

  context "as contributor" do
    let(:user) { create(:contributor) }

    it "403s" do
      [
        :index,
        :show,
        :flash_message,
        :error_page
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
      :flash_message,
      :error_page
    ]) }
  end
end