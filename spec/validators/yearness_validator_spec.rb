# frozen_string_literal: true

require "rails_helper"

RSpec.describe YearnessValidator do
  Object.const_set("ClassWithYear", Class.new do
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :year

    validates :year, yearness: true
  end)

  describe "valid" do
    context "with a one-digit year" do
      subject { ClassWithYear.new(year: "9") }

      it { is_expected.to be_valid }
    end

    context "with a two-digit year" do
      subject { ClassWithYear.new(year: "91") }

      it { is_expected.to be_valid }
    end

    context "with a three-digit year" do
      subject { ClassWithYear.new(year: "911") }

      it { is_expected.to be_valid }
    end

    context "with a four-digit year" do
      subject { ClassWithYear.new(year: "1911") }

      it { is_expected.to be_valid }
    end

    context "with nil" do
      subject { ClassWithYear.new(year: nil) }

      it { is_expected.to be_valid }
    end

    context "with blank" do
      subject { ClassWithYear.new(year: "") }

      it { is_expected.to be_valid }
    end
  end

  describe "invalid" do
    context "with a negative year" do
      subject { ClassWithYear.new(year: "-911") }

      it { is_expected.to_not be_valid }

      it "has error message" do
        subject.valid?

        is_expected.to have_error(year: :not_a_year)
      end
    end

    context "with a string" do
      subject { ClassWithYear.new(year: "foo") }

      it { is_expected.to_not be_valid }

      it "has error message" do
        subject.valid?

        is_expected.to have_error(year: :not_a_year)
      end
    end
  end
end
