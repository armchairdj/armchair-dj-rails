# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_atomically_validatable_model" do |invalid_params|
  let(     :attributes) { invalid_params.keys }
  let(:first_attribute) { attributes.first }

  describe "instance" do
    describe "valid_attributes?" do
      context "valid" do
        it "validates one attribute" do
          expect(subject.valid_attributes?(first_attribute)).to eq(true)

          expect(subject.errors.messages.keys).to have(0).items
        end

        it "validates multiple attributes" do
          expect(subject.valid_attributes?(attributes)).to eq(true)

          expect(subject.errors.messages.keys).to have(0).items
        end
      end

      context "invalid" do
        before(:each) do
          subject.assign_attributes(invalid_params)
        end

        it "validates one attribute wihout validating the others" do
          expect(subject.valid_attributes?(first_attribute)).to eq(false)
          expect(subject.errors.messages.keys.length       ).to eq(1)
          expect(subject.errors.messages.keys.first        ).to eq(first_attribute)
        end

        it "validates multiple attributes" do
          expect(subject.valid_attributes?(attributes)).to eq(false)

          expect(subject.errors.messages.keys.length  ).to eq(attributes.length)
          expect(subject.errors.messages.keys         ).to match_array(attributes)
        end
      end
    end

    describe "valid_attribute?" do
      before(:each) do
         allow(subject).to receive(:valid_attributes?)
        expect(subject).to receive(:valid_attributes?).with(first_attribute)
      end

      specify { subject.valid_attribute? first_attribute }
    end
  end
end
