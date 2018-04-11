RSpec.shared_examples "an enumable model" do |attributes|
  let(:instance) { create(:"minimal_#{described_class.model_name.param_key}") }

  attributes.each do |attribute|
    single_attr = attribute.to_s
    plural_attr = single_attr.pluralize

    context "for #{single_attr}" do
      context "class" do
        describe "self#human_#{plural_attr}" do
          specify { expect(
            described_class.respond_to?("human_#{plural_attr}")
          ).to eq(true) }
        end

        describe "self#alphabetical_human_#{plural_attr}" do
          specify { expect(
            described_class.respond_to?("alphabetical_human_#{plural_attr}")
          ).to eq(true) }
        end

        describe "self#human_#{single_attr}" do
          specify { expect(
            described_class.respond_to?("human_#{single_attr}")
          ).to eq(true) }
        end
      end

      context "instance" do
        describe "#human_#{single_attr}" do
          specify { expect(
            instance.respond_to?("human_#{single_attr}")
          ).to eq(true) }
        end
      end
    end
  end

  context "class" do
    describe "self#human_enum_collection" do
      specify { expect(described_class.respond_to?(:human_enum_collection)).to eq(true) }

      it "returns a 2D array for use in dropdowns" do

      end

      it "can alphabetize" do

      end
    end

    describe "self#human_enum_value" do
      specify { expect(described_class.respond_to?(:human_enum_value)).to eq(true) }
    end

    describe "self#enumable_attributes" do
      specify { expect(described_class.respond_to?(:enumable_attributes)).to eq(true) }
    end

    describe "enumable" do
      specify { expect(described_class.retrieve_enumable_attributes).to match_array(attributes) }
    end
  end
end
