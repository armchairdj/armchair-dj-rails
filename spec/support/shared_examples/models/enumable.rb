RSpec.shared_examples "an enumable model" do |attributes|
  let(:instance) { create(:"minimal_#{described_class.model_name.param_key}") }

  attributes.each do |attribute|
    single_attr = attribute.to_s
    plural_attr = single_attr.pluralize

    context "i18n for #{single_attr}" do
      described_class.send(plural_attr).keys.each do |val|
        it "has a localized string for #{val}" do
          expect(described_class.send("human_#{single_attr}", val)).to_not match(/translation missing/i)
        end
      end
    end

    context "for #{single_attr}" do
      context "class" do
        before(:each) do
          allow(described_class).to receive(plural_attr).and_return({
            "b" => 0,
            "a" => 1,
            "r" => 2
          })

          allow(I18n).to receive(:t).and_call_original

          allow(I18n).to receive(:t).with(
            "activerecord.attributes.#{described_class.model_name.i18n_key}.#{plural_attr}.b"
          ).and_return("Z.")

          allow(I18n).to receive(:t).with(
            "activerecord.attributes.#{described_class.model_name.i18n_key}.#{plural_attr}.a"
          ).and_return("Y.")

          allow(I18n).to receive(:t).with(
            "activerecord.attributes.#{described_class.model_name.i18n_key}.#{plural_attr}.r"
          ).and_return("X.")
        end

        describe "self#human_#{plural_attr}" do
          it "gives a 2D array mapping humanized values to enum values for use in dropdowns" do
            expected = [["Z.", "b"], ["Y.", "a"], ["X.", "r"]]
            actual   = described_class.send("human_#{plural_attr}")

            expect(actual).to eq(expected)
          end
        end

        describe "self#alphabetical_human_#{plural_attr}" do
          it "gives alphabetical 2D array for use in dropdowns" do
            expected = [["X.", "r"], ["Y.", "a"], ["Z.", "b"]]
            actual   = described_class.send("alphabetical_human_#{plural_attr}")

            expect(actual).to eq(expected)
          end
        end

        describe "self#human_#{single_attr}" do
          specify { expect(described_class.send("human_#{single_attr}", "b")).to eq("Z.") }
          specify { expect(described_class.send("human_#{single_attr}", "a")).to eq("Y.") }
          specify { expect(described_class.send("human_#{single_attr}", "r")).to eq("X.") }
        end
      end

      context "instance" do
        describe "#human_#{single_attr}" do
          it "calls class method" do
            allow(described_class).to receive("human_#{single_attr}")
            expect(described_class).to receive("human_#{single_attr}").with(instance.send("#{single_attr}"))

            instance.send("human_#{single_attr}")
          end
        end
      end
    end
  end

  context "class" do
    describe "self#human_enum_collection" do
      specify { expect(described_class.respond_to?(:human_enum_collection)).to eq(true) }
    end

    describe "self#human_enum_value" do
      specify { expect(described_class.respond_to?(:human_enum_value)).to eq(true) }
    end

    describe "self#enumable_attributes" do
      specify { expect(described_class.respond_to?(:enumable_attributes)).to eq(true) }
    end

    describe "self#retrieve_enumable_attributes" do
      specify { expect(described_class.retrieve_enumable_attributes).to match_array(attributes) }
    end
  end
end
