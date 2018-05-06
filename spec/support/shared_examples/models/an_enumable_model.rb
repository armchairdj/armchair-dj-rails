# frozen_string_literal: true

RSpec.shared_examples "an_enumable_model" do |attributes|
  let(:instance) { create_minimal_instance }

  context "class" do
    subject { described_class }

    describe "self#human_enum_collection" do
      it { should respond_to(:human_enum_collection) }
    end

    describe "self#human_enum_collection_with_keys" do
      it { should respond_to(:human_enum_collection_with_keys) }
    end

    describe "self#human_enum_value" do
      it { should respond_to(:human_enum_value) }
    end

    describe "self#enumable_attributes" do
      it { should respond_to(:enumable_attributes) }
    end

    describe "self#retrieve_enumable_attributes" do
      specify { expect(described_class.retrieve_enumable_attributes).to match_array(attributes) }
    end
  end

  attributes.each do |attribute|
    single_attr = attribute.to_s
    plural_attr = single_attr.pluralize
    i18n_key    = "activerecord.attributes.#{described_class.model_name.i18n_key}.#{plural_attr}"

    context "i18n for #{single_attr}" do
      context "singular" do
        described_class.send(plural_attr).keys.each do |val|
          it "has a localized string for #{val}" do
            expect(described_class.send("human_#{single_attr}", val)).to_not match(/translation missing/i)
          end
        end
      end
    end

    context "for #{single_attr}" do
      context "class" do
        context "basic behavior" do
          before(:each) do
            allow(described_class).to receive(plural_attr).and_return({
              "b" => 0,
              "a" => 1,
              "r" => 2
            })

            allow(I18n).to receive(:t).and_call_original

            allow(I18n).to receive(:t).with("#{i18n_key}.b").and_return("Z.")
            allow(I18n).to receive(:t).with("#{i18n_key}.a").and_return("Y.")
            allow(I18n).to receive(:t).with("#{i18n_key}.r").and_return("X.")
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

          describe "self#human_#{plural_attr}_with_keys" do
            it "gives a 2D array mapping humanized values to enum values for use in dropdowns" do
              expected = [["Z.", "b", 0], ["Y.", "a", 1], ["X.", "r", 2]]
              actual   = described_class.send("human_#{plural_attr}_with_keys")

              expect(actual).to eq(expected)
            end
          end

          describe "self#human_#{single_attr}" do
            specify { expect(described_class.send("human_#{single_attr}", "b")).to eq("Z.") }
            specify { expect(described_class.send("human_#{single_attr}", "a")).to eq("Y.") }
            specify { expect(described_class.send("human_#{single_attr}", "r")).to eq("X.") }
          end
        end

        context "translations" do
          specify "are not missing" do
            described_class.send("human_#{plural_attr}").each do |translation|
              expect(translation.first).to_not match(/translation missing/)
            end
          end
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
end
