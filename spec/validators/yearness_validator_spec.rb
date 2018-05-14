require "rails_helper"

describe YearnessValidator do
  Object.const_set("ClassWithYear", Class.new do
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :year

    validates :year, yearness: true
  end)

  context "valid" do
    context "with a one-digit year" do
      subject { ClassWithYear.new(year: "9") }

      it { should be_valid }
    end

    context "with a two-digit year" do
      subject { ClassWithYear.new(year: "91") }

      it { should be_valid }
    end

    context "with a three-digit year" do
      subject { ClassWithYear.new(year: "911") }

      it { should be_valid }
    end

    context "with a four-digit year" do
      subject { ClassWithYear.new(year: "1911") }

      it { should be_valid }
    end

    context "with nil" do
      subject { ClassWithYear.new(year: nil) }

      it { should be_valid }
    end

    context "with blank" do
      subject { ClassWithYear.new(year: "") }

      it { should be_valid }
    end
  end

  context "invalid" do
    context "with a negative year" do
      subject { ClassWithYear.new(year: "-911") }

      it { should_not be_valid }

      it "should have error message" do
        subject.valid?

        should have_errors(year: :not_a_year)
      end
    end

    context "with a string" do
      subject { ClassWithYear.new(year: "foo") }

      it { should_not be_valid }

      it "should have error message" do
        subject.valid?

        should have_errors(year: :not_a_year)
      end
    end
  end
end
