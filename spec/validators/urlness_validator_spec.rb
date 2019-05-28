# frozen_string_literal: true

require "rails_helper"

RSpec.describe UrlnessValidator do
  Object.const_set("ClassWithUrl", Class.new do
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :url

    validates :url, urlness: true
  end)

  describe "valid" do
    context "with a valid http url" do
      subject { ClassWithUrl.new(url: "http://www.example.com") }

      it { is_expected.to be_valid }
    end

    context "with a valid https url" do
      subject { ClassWithUrl.new(url: "https://www.example.com") }

      it { is_expected.to be_valid }
    end
  end

  describe "invalid" do
    context "with a non-URI" do
      subject { ClassWithUrl.new(url: "not a url") }

      it { is_expected.to_not be_valid }

      it "has error message" do
        subject.valid?

        is_expected.to have_error(url: :not_a_url)
      end
    end

    context "with a non-URL URI" do
      subject { ClassWithUrl.new(url: "protocol://foo/bar/bat") }

      it { is_expected.to_not be_valid }

      it "has error message" do
        subject.valid?

        is_expected.to have_error(url: :not_a_url)
      end
    end
  end
end
